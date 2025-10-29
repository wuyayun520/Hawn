import 'package:flutter/material.dart';

/// 通用背景组件
/// 为所有页面提供统一的背景图片
class CommonBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;

  const CommonBackground({
    super.key,
    required this.child,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage ?? 'assets/hawn_all_bg.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}

/// 带通用背景的Scaffold组件
/// 简化页面创建，自动应用背景图片
class BackgroundScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final String? backgroundImage;

  const BackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: CommonBackground(
        backgroundImage: backgroundImage,
        child: body,
      ),
    );
  }
}
