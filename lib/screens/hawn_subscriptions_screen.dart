import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionsPage extends StatefulWidget {
  final int initialIndex;
  const SubscriptionsPage({super.key, this.initialIndex = 0});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> with TickerProviderStateMixin {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isLoading = false; // 改为false，不在初始化时加载
  bool _purchasePending = false;
  int _selectedIndex = 0;
  bool _isVip = false;
  DateTime? _vipExpiry;
  DateTime? _lastSnackBarTime;
  bool _productsLoaded = false; // 新增：标记商品是否已加载

  // 订阅商品配置
  final List<_VipPlan> _plans = [
    _VipPlan(
      title: '12.99',
      subTitle: 'Per week',
      total: 'Total \$12.99',
      desc: '+7 Days ',
      productId: 'HawnWeekVIP',
      popular: false,
    ),
    _VipPlan(
      title: '49.99',
      subTitle: 'Per month',
      total: 'Total \$49.99',
      desc: '+30 Days ',
      productId: 'HawnMonthVIP',
      popular: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint("Error in IAP Stream: $error");
    });
    // 移除自动初始化内购，改为延迟加载
    _loadVipStatus();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // 新增：延迟加载商品信息，只在用户需要购买时才加载
  Future<void> _loadProductsIfNeeded() async {
    if (_productsLoaded) {
      return; // 如果已经加载过，直接返回
    }
    
    setState(() {
      _isLoading = true;
    });
    
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("Store not available");
      return;
    }
    
    final Set<String> productIds = _plans.map((e) => e.productId).toSet();
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
      setState(() {
        _products = response.productDetails;
        _isLoading = false;
        _productsLoaded = true; // 标记为已加载
      });
      
      if (response.productDetails.isEmpty) {
        _showSnackBar("No subscription products available");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("Failed to load subscription products: $e");
    }
  }

  Future<void> _loadVipStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVip = prefs.getBool('isVip') ?? false;
      final expiryStr = prefs.getString('vipExpiry');
      _vipExpiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase status: ${purchaseDetails.status}');
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            _purchasePending = false;
          });
          _showSnackBar("Purchase failed: ${purchaseDetails.error?.message ?? 'Unknown error'}");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          debugPrint('Successful purchase/restore: ${purchaseDetails.productID}');
          await _handleSuccessfulPurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() {
            _purchasePending = false;
          });
          _showSnackBar("Purchase was canceled");
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    setState(() {
      _purchasePending = false;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVip', true);
    // 计算有效期和VIP类型
    DateTime now = DateTime.now();
    DateTime expiry;
    String vipType;
    if (purchaseDetails.productID == 'HawnWeekVIP') {
      expiry = now.add(const Duration(days: 7));
      vipType = 'weekly';
    } else if (purchaseDetails.productID == 'HawnMonthVIP') {
      expiry = now.add(const Duration(days: 30));
      vipType = 'monthly';
    } else {
      expiry = now;
      vipType = 'unknown';
    }
    await prefs.setString('vipExpiry', expiry.toIso8601String());
    await prefs.setString('vip_type', vipType);
          _showSnackBar("Hawn Premium activated!");
    await _loadVipStatus();
  }

  void _showSnackBar(String msg) {
    final now = DateTime.now();
    if (_lastSnackBarTime != null && now.difference(_lastSnackBarTime!).inSeconds < 3) {
      return;
    }
    _lastSnackBarTime = now;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: const Color(0xFF2E7D7A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _processPurchase() async {
    // 在购买前确保商品已加载
    if (!_productsLoaded) {
      await _loadProductsIfNeeded();
    }
    
    final plan = _plans[_selectedIndex];
    final ProductDetails? product = _products.firstWhereOrNull((p) => p.id == plan.productId);
    if (product == null) {
      _showSnackBar("Product not available");
      return;
    }
    setState(() {
      _purchasePending = true;
    });
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
      _showSnackBar("Error starting purchase: $e");
    }
  }

  Future<void> _restorePurchases() async {
    // 在恢复前确保商品已加载
    if (!_productsLoaded) {
      await _loadProductsIfNeeded();
    }
    
    setState(() {
      _purchasePending = true;
    });
    
    try {
      debugPrint('Starting restore purchases...');
      await _inAppPurchase.restorePurchases();
      _showSnackBar("Restoring purchases... Please wait.");
      
      // 给一些时间让恢复过程完成
      await Future.delayed(const Duration(seconds: 2));
      
      // 重新加载VIP状态以检查是否有恢复的购买
      await _loadVipStatus();
      
      if (_isVip) {
        _showSnackBar("Purchases restored successfully! Hawn Premium activated.");
      } else {
        _showSnackBar("No previous purchases found to restore.");
      }
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
      _showSnackBar("Error restoring purchases: $e");
    } finally {
      setState(() {
        _purchasePending = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackBar('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE1BEE7), // Light purple
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF9355FF),
                    strokeWidth: 3,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 自定义AppBar
                      _buildCustomAppBar(),
                      const SizedBox(height: 30),
                      
                      // VIP状态卡片（如果已激活）
                      if (_isVip && _vipExpiry != null) ...[
                        _buildVipStatusCard(),
                        const SizedBox(height: 30),
                      ],
                      
                      // 标题
                      const Text(
                        'Choose Your Plan',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // 订阅计划卡片
                      _buildSubscriptionCards(),
                      const SizedBox(height: 30),
                      
                      // VIP权益标题
                      const Text(
                        'VIP Benefits',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // VIP权益列表
                      _buildBenefitsList(),
                      const SizedBox(height: 30),
                      
                      // 购买按钮
                      _buildPurchaseButton(),
                      const SizedBox(height: 20),
                      
                      // 恢复购买按钮
                      _buildRestoreButton(),
                      const SizedBox(height: 20),
                      
                      // 协议链接
                      _buildLegalSection(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'VIP Center',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVipStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFFCE93D8)], // 紫色渐变
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAB47BC).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VIP Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires: ${_vipExpiry!.year}-${_vipExpiry!.month.toString().padLeft(2, '0')}-${_vipExpiry!.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCards() {
    return Column(
      children: _plans.asMap().entries.map((entry) {
        final index = entry.key;
        final plan = entry.value;
        final isSelected = index == _selectedIndex;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: isSelected 
                    ? const LinearGradient(
                        colors: [Color(0xFFAB47BC), Color(0xFFCE93D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Colors.white, Color(0xFFF8F8F8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(20),
                border: isSelected 
                    ? Border.all(color: const Color(0xFFAB47BC), width: 2)
                    : Border.all(color: const Color(0xFFE0E0E0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: isSelected 
                        ? const Color(0xFFAB47BC).withOpacity(0.3)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: isSelected ? 20 : 10,
                    offset: Offset(0, isSelected ? 8 : 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 主要内容
                  Row(
                    children: [
                      // 左侧：价格和时长
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '\$${plan.title}',
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? Colors.white.withOpacity(0.2)
                                        : const Color(0xFFAB47BC).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    plan.subTitle,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFFAB47BC),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 4),
                            Text(
                              plan.desc,
                              style: TextStyle(
                                color: isSelected ? Colors.white60 : Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 右侧：选中标记和推荐标签
                      Column(
                        children: [
                          if (plan.popular)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'POPULAR',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Colors.white
                                  : const Color(0xFFAB47BC),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected 
                                      ? Colors.white.withOpacity(0.3)
                                      : const Color(0xFFAB47BC).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isSelected ? Icons.check : Icons.radio_button_unchecked,
                              color: isSelected 
                                  ? const Color(0xFFAB47BC)
                                  : Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
               
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

   Widget _buildBenefitsList() {
    final List<_Privilege> privileges = _selectedIndex == 0 ? [
      _Privilege(icon: Icons.play_circle_outline, text: 'Unlimited viewing of redirected videos'),
      _Privilege(icon: Icons.block, text: 'Ad-free experience'),
      _Privilege(icon: Icons.favorite, text: 'Give unlimited likes to the work'),
      _Privilege(icon: Icons.face_retouching_natural, text: 'Unlimited modification of the avatar')
    ] : [
      _Privilege(icon: Icons.play_circle_outline, text: 'Unlimited viewing of redirected videos'),
      _Privilege(icon: Icons.block, text: 'Ad-free experience'),
      _Privilege(icon: Icons.favorite, text: 'Give unlimited likes to the work'),
      _Privilege(icon: Icons.face_retouching_natural, text: 'Unlimited modification of the avatar'),  
      _Privilege(icon: Icons.message, text: 'View the chat message list'),  
    ];

    return Column(
      children: privileges.map((privilege) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              privilege.icon,
              color: const Color(0xFFAB47BC),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                privilege.text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildPurchaseButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFFCE93D8)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAB47BC).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _purchasePending ? null : _processPurchase,
          child: Center(
            child: _purchasePending
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Start VIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestoreButton() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _purchasePending ? null : _restorePurchases,
          child: Center(
            child: _purchasePending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: const Color(0xFFAB47BC),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Restore Purchases',
                    style: TextStyle(
                      color: Color(0xFFAB47BC),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegalSection() {
    return Column(
      children: [
        // 协议链接
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _launchURL('https://www.apple.com/legal/internet-services/terms/site.html'),
              child: const Text(
                'EULA',
                style: TextStyle(
                  color: Color(0xFFAB47BC),
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _launchURL('https://www.privacypolicies.com/live/8510618a-9855-426d-bcf8-cd9d1866960f'),
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Color(0xFFAB47BC),
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // 退订说明
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to Cancel Subscription',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'To cancel your subscription:',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Open Settings on your iPhone/iPad',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const Text(
                '2. Tap your name at the top',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const Text(
                '3. Tap "Subscriptions"',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const Text(
                '4. Find "Hawn Premium" and tap it',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const Text(
                '5. Tap "Cancel Subscription"',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your subscription will remain active until the end of the current billing period.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VipPlan {
  final String title;
  final String subTitle;
  final String total;
  final String desc;
  final String productId;
  final bool popular;
  const _VipPlan({
    required this.title,
    required this.subTitle,
    required this.total,
    required this.desc,
    required this.productId,
    required this.popular,
  });
}


extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class _Privilege {
  final IconData icon;
  final String text;
  const _Privilege({required this.icon, required this.text});
}