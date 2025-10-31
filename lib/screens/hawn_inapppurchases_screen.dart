import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

class GoldProduct {
  final String amountStr;
  final String productId;
  final double price;
  int get amount => int.tryParse(amountStr) ?? 0;
  const GoldProduct(this.amountStr, this.productId, this.price);
}


class GoldProducts {
  static const List<GoldProduct> all = [
    GoldProduct('32', 'Hawn', 0.99),
    GoldProduct('60', 'Hawn1', 1.99),
    GoldProduct('96', 'Hawn2', 2.99),
    GoldProduct('155', 'Hawn4', 4.99),
    GoldProduct('189', 'Hawn5', 5.99),
    GoldProduct('359', 'Hawn9', 9.99),
    GoldProduct('729', 'Hawn19', 19.99),
    GoldProduct('1869', 'Hawn49', 49.99),
    GoldProduct('3799', 'Hawn99', 99.99),
    GoldProduct('5999', 'Hawn159', 159.99),
    GoldProduct('9059', 'Hawn239', 239.99),
  ];
}

class InAppPurchasesPage extends StatefulWidget {
  const InAppPurchasesPage({super.key});

  @override
  State<InAppPurchasesPage> createState() => _InAppPurchasesPageState();
}

class _InAppPurchasesPageState extends State<InAppPurchasesPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isLoading = true;
  bool _purchasePending = false;
  int _goldCoins = 0;
  final Set<String> _processedPurchases = {}; // 跟踪已处理的购买
  bool _isInitialized = false; // 标记是否已初始化
  int _selectedProductIndex = 0; // 跟踪选中的商品索引

  List<GoldProduct> get _goldProducts => GoldProducts.all;

  @override
  void initState() {
    super.initState();
    
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint("Error in IAP Stream: $error");
    });
    _loadGoldCoins();
    _initInAppPurchase();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadGoldCoins() async {
    final prefs = await SharedPreferences.getInstance();
    int coins = prefs.getInt('petCoins') ?? 0;
    debugPrint('Loading star coins: $coins');
    setState(() {
      _goldCoins = coins;
      // 如果还没有初始化完成，在这里也设置标志
      if (!_isInitialized) {
        _isInitialized = true;
        debugPrint('Initialized from _loadGoldCoins');
      }
    });
  }

  Future<void> _saveGoldCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint('Saving star coins: current=$_goldCoins, adding=$amount, new=${_goldCoins + amount}');
    debugPrint('Call stack: ${StackTrace.current}');
    setState(() {
      _goldCoins += amount;
    });
    await prefs.setInt('petCoins', _goldCoins);
  }

  Future<void> _initInAppPurchase() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    debugPrint('Store availability: $isAvailable');
    
    if (!isAvailable) {
      setState(() {
        _isLoading = false;
        _isInitialized = true; // 即使出错也标记为已初始化
      });
      return;
    }
    
    final Set<String> productIds = _goldProducts.map((e) => e.productId).toSet();
    debugPrint('Querying products: $productIds');
    
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
      debugPrint('Found ${response.productDetails.length} products');
      debugPrint('Product IDs: ${response.productDetails.map((p) => p.id).toList()}');
      
      setState(() {
        _products = response.productDetails;
        _isLoading = false;
        _isInitialized = true; // 标记初始化完成
      });
      debugPrint('InAppPurchase initialized successfully');
      
      if (response.productDetails.isEmpty) {
        // _showSnackBar("No products available");
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
      setState(() {
        _isLoading = false;
        _isInitialized = true; // 即使出错也标记为已初始化
      });
      _showSnackBar("Failed to load products: $e");
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    // 如果页面还没有初始化完成，忽略购买更新
    if (!_isInitialized) {
      debugPrint('Ignoring purchase updates during initialization');
      return;
    }
    
    for (var purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase status: ${purchaseDetails.status} for product: ${purchaseDetails.productID}');
      
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
          // 处理新购买和恢复的购买
          _handleSuccessfulPurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() {
            _purchasePending = false;
          });
        }
        // 移除重复的completePurchase调用，现在在_handleSuccessfulPurchase中处理
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    // 检查是否已经处理过这个购买
    String purchaseKey = '${purchaseDetails.productID}_${purchaseDetails.purchaseID}_${purchaseDetails.status}';
    if (_processedPurchases.contains(purchaseKey)) {
      debugPrint('Purchase already processed: $purchaseKey');
      return;
    }
    
    // 添加到已处理列表
    _processedPurchases.add(purchaseKey);
    
    debugPrint('Handling successful purchase: ${purchaseDetails.productID} (${purchaseDetails.status})');
    debugPrint('Available product IDs: ${_goldProducts.map((p) => p.productId).toList()}');
    
    setState(() {
      _purchasePending = false;
    });
    
    final product = _goldProducts.firstWhere(
      (e) => e.productId == purchaseDetails.productID, 
      orElse: () {
        debugPrint('Product not found in configuration: ${purchaseDetails.productID}');
        return GoldProduct('', '', 0);
      }
    );
    
    if (product.amount > 0) {
      debugPrint('Processing purchase: ${product.amount} coins for product ${purchaseDetails.productID}');
      await _saveGoldCoins(product.amount);
      _showSnackBar("Purchase successful! +${product.amount} Star Coins");
    } else {
      debugPrint('Product amount is 0 or product not found: ${purchaseDetails.productID}');
    }
    
    // 总是清除订单
    debugPrint('Completing purchase: ${purchaseDetails.productID}');
    await _inAppPurchase.completePurchase(purchaseDetails);
  }

  void _showSnackBar(String msg) {
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

  Future<void> _processPurchase(String productId) async {
    debugPrint('Attempting to purchase product: $productId');
    debugPrint('Available products: ${_products.map((p) => p.id).toList()}');
    
    final ProductDetails? product = _products.firstWhereOrNull((p) => p.id == productId);
    if (product == null) {
      debugPrint('Product not found: $productId');
      _showSnackBar("Product not available");
      return;
    }
    
    debugPrint('Product found: ${product.id} - ${product.title} - ${product.price}');
    
    setState(() {
      _purchasePending = true;
    });
    
    try {
      // 添加短暂延迟，确保系统准备好
      await Future.delayed(const Duration(milliseconds: 500));
      
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      debugPrint('Starting purchase for: ${product.id}');
      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      debugPrint('Purchase initiated successfully');
    } catch (e) {
      debugPrint('Error starting purchase: $e');
      setState(() {
        _purchasePending = false;
      });
      _showSnackBar("Error starting purchase: $e");
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
                      
                      // 钱包余额卡片
                      _buildWalletBalanceCard(),
                      const SizedBox(height: 30),
                      
                      // 选择充值金额标题
                      const Text(
                        'Select Top-up Amount',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // 商品网格
                      _buildProductGrid(),
                      const SizedBox(height: 30),
                      
                      // 充值按钮
                      _buildRechargeButton(),
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
          'Wallet',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWalletBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFAB47BC), Color(0xFFCE93D8)], // 紫色渐变
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_goldCoins',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gold Coins',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // 金币图标
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Image.asset(
              'assets/hawn_user_coin.webp',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.account_balance_wallet,
                  size: 40,
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Column(
      children: _goldProducts.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final product = _products.firstWhereOrNull((p) => p.id == item.productId);
        final priceStr = product?.price != null 
            ? product!.price.replaceAll('US\$', '\$')
            : '\$${item.price.toStringAsFixed(2)}';
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildProductCard(item, priceStr, index == _selectedProductIndex),
        );
      }).toList(),
    );
  }

  Widget _buildProductCard(GoldProduct item, String priceStr, bool isSelected) {
    return GestureDetector(
      onTap: _purchasePending ? null : () {
        // 切换选中状态
        setState(() {
          _selectedProductIndex = _goldProducts.indexOf(item);
        });
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFAB47BC) : const Color(0xFFF3E5F5), // 浅紫色背景
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
              ? Border.all(color: const Color(0xFFAB47BC), width: 2)
              : Border.all(color: const Color(0xFFE1BEE7), width: 1),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? const Color(0xFFAB47BC).withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 左侧金币图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700), // 金黄色
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/hawn_user_coin.webp',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.attach_money,
                        size: 24,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 中间金币数量信息
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.amount} Gold Coins',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Premium Currency',
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // 右侧价格按钮
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  priceStr,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFAB47BC) : const Color(0xFFAB47BC),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 选中标记
              if (isSelected) ...[
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFFAB47BC),
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRechargeButton() {
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
          onTap: _purchasePending ? null : () {
            // 使用选中的商品进行购买
            if (_selectedProductIndex < _goldProducts.length) {
              final selectedProduct = _goldProducts[_selectedProductIndex];
              _processPurchase(selectedProduct.productId);
            }
          },
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
                    'Recharge Now',
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
}

extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}