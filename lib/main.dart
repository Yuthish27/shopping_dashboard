import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';
import 'auth_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Shopper',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.spaceGroteskTextTheme(),
      ),
      home: AppController(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppController extends StatefulWidget {
  @override
  _AppControllerState createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  bool isAuthenticated = false;
  String userName = '';
  String selectedCurrency = 'USD';
  bool showTransition = false;

  void _handleAuthComplete(String name, String currency) {
    setState(() {
      showTransition = true;
    });
    
    // After transition animation completes
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        isAuthenticated = true;
        userName = name;
        selectedCurrency = currency;
        showTransition = false;
      });
    });
  }

  void _handleLogout() {
    setState(() {
      showTransition = true;
    });
    
    // After transition animation completes
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        isAuthenticated = false;
        userName = '';
        selectedCurrency = 'USD';
        showTransition = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridTransitionOverlay(
      showTransition: showTransition,
      child: isAuthenticated
          ? HomePage(
              onLogout: _handleLogout,
              currency: selectedCurrency,
              userName: userName,
            )
          : AuthWrapper(
              onAuthComplete: _handleAuthComplete,
            ),
    );
  }
}

class GridTransitionOverlay extends StatefulWidget {
  final Widget child;
  final bool showTransition;
  final VoidCallback? onTransitionComplete;

  GridTransitionOverlay({
    required this.child,
    required this.showTransition,
    this.onTransitionComplete,
  });

  @override
  _GridTransitionOverlayState createState() => _GridTransitionOverlayState();
}

class _GridTransitionOverlayState extends State<GridTransitionOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(GridTransitionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showTransition && !oldWidget.showTransition) {
      _controller.forward().then((_) {
        if (widget.onTransitionComplete != null) {
          widget.onTransitionComplete!();
        }
      });
    } else if (!widget.showTransition) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showTransition)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: GridTransitionPainter(),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class GridTransitionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Black background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

    // White grid lines
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.0;

    const double gridSize = 30.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}




// MAIN DASHBOARD - HomePage
class HomePage extends StatefulWidget {
  final VoidCallback onLogout;
  final String currency;
  final String userName;
  
  HomePage({
    required this.onLogout,
    required this.currency,
    required this.userName,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedSegment = 0;
  int selectedNavIndex = 0;

  // Hover states for all interactive elements
  bool _isMainCardHovered = false;
  bool _isQuickAction1Hovered = false;
  bool _isQuickAction2Hovered = false;
  bool _isQuickAction3Hovered = false;
  bool _isQuickAction4Hovered = false;
  bool _isQuickAction5Hovered = false;
  bool _isQuickAction6Hovered = false;
  bool _isQuickAction7Hovered = false;
  bool _isQuickAction8Hovered = false;
  bool _isCenterButtonHovered = false;

  // Design colors
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color neonPurple = Color(0xFFBF5AF2);
  static const Color iconBgDark = Color(0xFF2C2C2E);
  static const Color gradientStart = Color(0xFF3A3A3C);
  static const Color gradientEnd = Color(0xFF1C1C1E);

  // Currency symbols mapping
  Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'CHF': 'CHF',
    'CNY': '¥',
    'INR': '₹',
  };

  String get currencySymbol => currencySymbols[widget.currency] ?? '\$';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF000000), // Black background
        ),
        child: CustomPaint(
          painter: GridBackgroundPainter(),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 400,
                ),
                child: Stack(
                  children: [
                    // Main scrollable content
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, isMobile ? 120 : 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(isMobile),
                          SizedBox(height: 24),
                          _buildMainCard(isMobile),
                          SizedBox(height: 24),
                          _buildQuickActionsHeader(isMobile),
                          SizedBox(height: 16),
                          _buildQuickActionsGrid(isMobile),
                          SizedBox(height: 24),
                          _buildSegmentedControl(isMobile),
                          SizedBox(height: 16),
                          _buildActivityList(isMobile),
                        ],
                      ),
                    ),
                    // Fixed floating navigation
                    _buildFloatingNav(isMobile),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Hello, ${widget.userName}',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Currency indicator badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: neonPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: neonPurple.withOpacity(0.3)),
              ),
              child: Text(
                widget.currency,
                style: TextStyle(
                  color: neonPurple,
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 12),
            // Notification bell with indicator
            Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: textSecondary,
                  size: isMobile ? 24 : 28,
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: neonPurple,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: backgroundDark, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
            // Profile picture with logout functionality
            GestureDetector(
              onTap: widget.onLogout,
              child: Container(
                width: isMobile ? 36 : 40,
                height: isMobile ? 36 : 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 18 : 20),
                  border: Border.all(color: neonPurple, width: 2),
                  image: DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCOFtJZR1twy0NIXdQ-YS1Xgz6NC9T_j274rGucde-r6Z3jbY54KWKctz71v7UIWkaSPrUSzvAuMLvpeD_Bax37t7zkDwYGwJVn7jE4h596z_gxi__eb2f08OAk1oBlxNmvSBUX4rhx1QZQYFg_FBwRFr2YIuwtNjx66gqeQKIAEPFStzxGfAhq_8vgFx8EGcwfwY6ESQr3HuW129iXZ0fae-FVgF3Vxjpa2JG1PG9OoL0AbJTagaKZ62RSFOswL1eHnTAcjHMa68gX'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainCard(bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isMainCardHovered = true),
      onExit: (_) => setState(() => _isMainCardHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 20 : 24),
        transform: Matrix4.identity()..translate(0.0, _isMainCardHovered && !isMobile ? -5.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStart, gradientEnd],
          ),
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          border: Border.all(
            color: _isMainCardHovered && !isMobile
              ? neonPurple.withOpacity(0.5) 
              : Colors.white.withOpacity(0.1)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: isMobile ? 20 : 40,
              offset: Offset(0, isMobile ? 5 : 10),
            ),
            if (_isMainCardHovered && !isMobile) ...[
              BoxShadow(
                color: neonPurple.withOpacity(0.4),
                blurRadius: 30,
                offset: Offset(0, 8),
                spreadRadius: 2,
              ),
            ] else
              BoxShadow(
                color: neonPurple.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
          ],
        ),
        child: Stack(
          children: [
            // Animated glow effect
            Positioned(
              top: -40,
              right: -40,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _isMainCardHovered && !isMobile ? 200 : 160,
                height: _isMainCardHovered && !isMobile ? 200 : 160,
                decoration: BoxDecoration(
                  color: neonPurple.withOpacity(_isMainCardHovered && !isMobile ? 0.25 : 0.15),
                  borderRadius: BorderRadius.circular(_isMainCardHovered && !isMobile ? 100 : 80),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Purchases',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: isMobile ? 12 : 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${currencySymbol}1,250.75',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: isMobile ? 28 : 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: isMobile ? 40 : 48,
                      height: isMobile ? 40 : 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Icon(
                        Icons.auto_graph,
                        color: textPrimary,
                        size: isMobile ? 20 : 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 16 : 24),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                      size: isMobile ? 14 : 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '+12% vs last month',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        Icon(
          Icons.more_horiz,
          color: textSecondary,
          size: isMobile ? 20 : 24,
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid(bool isMobile) {
    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          // First row
          _buildQuickActionCard(Icons.storefront, 'Stores', 0, isMobile),
          _buildQuickActionCard(Icons.shopping_bag_outlined, 'Online', 1, isMobile),
          _buildQuickActionCard(Icons.card_giftcard_outlined, 'E-Gift', 2, isMobile),
          _buildQuickActionCard(Icons.search, 'Search', 3, isMobile),
          
          // Second row
          _buildQuickActionCard(Icons.local_offer_outlined, 'Deals', 4, isMobile),
          _buildQuickActionCard(Icons.favorite_outline, 'Wishlist', 5, isMobile),
          _buildQuickActionCard(Icons.receipt_long_outlined, 'Orders', 6, isMobile),
          _buildQuickActionCard(Icons.support_agent_outlined, 'Support', 7, isMobile),
        ],
      );
    } else {
      // Desktop layout - 2 rows of 4 cards each
      return Column(
        children: [
          // First row
          Row(
            children: [
              Expanded(child: _buildQuickActionCard(Icons.storefront, 'Stores', 0, isMobile)),
              SizedBox(width: 12),
              Expanded(child: _buildQuickActionCard(Icons.shopping_bag_outlined, 'Online', 1, isMobile)),
              SizedBox(width: 12),
              Expanded(child: _buildQuickActionCard(Icons.card_giftcard_outlined, 'E-Gift', 2, isMobile)),
              SizedBox(width: 12),
              Expanded(child: _buildQuickActionCard(Icons.search, 'Search', 3, isMobile)),
            ],
          ),
          SizedBox(height: 12),
          // Second row
          Row(
            children: [
              Expanded(child: _buildQuickActionCard(Icons.local_offer_outlined, 'Deals', 4, isMobile)),
              SizedBox(width: 12),
              Expanded(child: _buildQuickActionCard(Icons.favorite_outline, 'Wishlist', 5, isMobile)),
              SizedBox(width: 12),
              Expanded(child: _buildQuickActionCard(Icons.receipt_long_outlined, 'Orders', 6, isMobile)),
              SizedBox(width: 12),
              Expanded(child: _buildQuickActionCard(Icons.support_agent_outlined, 'Support', 7, isMobile)),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildQuickActionCard(IconData icon, String label, int index, bool isMobile) {
    bool isHovered = index == 0 ? _isQuickAction1Hovered :
                    index == 1 ? _isQuickAction2Hovered :
                    index == 2 ? _isQuickAction3Hovered :
                    index == 3 ? _isQuickAction4Hovered :
                    index == 4 ? _isQuickAction5Hovered :
                    index == 5 ? _isQuickAction6Hovered :
                    index == 6 ? _isQuickAction7Hovered :
                    _isQuickAction8Hovered;

    return MouseRegion(
      onEnter: (_) => setState(() {
        if (index == 0) _isQuickAction1Hovered = true;
        if (index == 1) _isQuickAction2Hovered = true;
        if (index == 2) _isQuickAction3Hovered = true;
        if (index == 3) _isQuickAction4Hovered = true;
        if (index == 4) _isQuickAction5Hovered = true;
        if (index == 5) _isQuickAction6Hovered = true;
        if (index == 6) _isQuickAction7Hovered = true;
        if (index == 7) _isQuickAction8Hovered = true;
      }),
      onExit: (_) => setState(() {
        if (index == 0) _isQuickAction1Hovered = false;
        if (index == 1) _isQuickAction2Hovered = false;
        if (index == 2) _isQuickAction3Hovered = false;
        if (index == 3) _isQuickAction4Hovered = false;
        if (index == 4) _isQuickAction5Hovered = false;
        if (index == 5) _isQuickAction6Hovered = false;
        if (index == 6) _isQuickAction7Hovered = false;
        if (index == 7) _isQuickAction8Hovered = false;
      }),
      child: GestureDetector(
        onTap: () => print('Tapped $label'),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isMobile ? 10 : 12),
          transform: Matrix4.identity()..translate(0.0, isHovered && !isMobile ? -8.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            border: Border.all(
              color: isHovered && !isMobile
                ? neonPurple.withOpacity(0.5) 
                : Colors.white.withOpacity(0.08)
            ),
            boxShadow: [
              if (isHovered && !isMobile) ...[
                BoxShadow(
                  color: neonPurple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  color: isHovered && !isMobile
                    ? neonPurple.withOpacity(0.2) 
                    : iconBgDark,
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                ),
                child: Icon(
                  icon,
                  color: isHovered && !isMobile ? neonPurple : textPrimary,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isHovered && !isMobile ? neonPurple : textSecondary,
                  fontSize: isMobile ? 12 : 16, // Updated font size
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: iconBgDark,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(child: _buildSegmentButton('My Activity', 0, isMobile)),
          Expanded(child: _buildSegmentButton('Community', 1, isMobile)),
          Expanded(child: _buildSegmentButton('Trends', 2, isMobile)),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text, int index, bool isMobile) {
    bool isActive = selectedSegment == index;
    return GestureDetector(
      onTap: () => setState(() => selectedSegment = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: isMobile ? 6 : 8),
        decoration: BoxDecoration(
          color: isActive ? neonPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          boxShadow: isActive
            ? [BoxShadow(color: neonPurple.withOpacity(0.4), blurRadius: 14, offset: Offset(0, 4))]
            : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? textPrimary : textSecondary,
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList(bool isMobile) {
    return Column(
      children: [
        _buildActivityItem(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBWMt1Np4fuRp2M3tvfBFe0tQmbfyl21pf0IC6J-nn556NXiUfXXFGubC_KKME5DKoM06AKO91i4yk-Pdj0BaHohaQBvAV1-n0_U3xjDWjZAXU_L_xLimXYge2jvBCaqilOLYBYcIitP0HR1kWduRSsUeRozvdNTcOAiTyd7foZ8wH_4AgtjINDEkXDtO5PS2PAUHwP5O4AoiWxlCigu916FRaBf-umC1aGE-xKpLIoZ54JzJmnxTgy94VsvS0P2AKGxhvwWEor6lJa',
          'GitHub Store', '${currencySymbol}25.00', 'Oct 28', '10:42 AM', isMobile,
        ),
        SizedBox(height: 12),
        _buildActivityItem(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD7VpDunUrQ7rm5st9g0o_S7LhXH76QS2fbisRhTITEvnrNLAzfZbO49niSp6DaBExbOUFG5mGIuAqcK0BREEbA07bxfy1j_kS0VKssLHeaBYXcXPJwWXcd5r3B6MhsPvxRFV4R_Ipk_nsmmIX2PYjIn_-wVBoU4y_dkrQccbyIW6A7B_uUIFx7LJIfqxvneuOCbPa3tK3Vbg9HKGZBkZ2r0n8C1Nf38JcBuRnBFgvdrLqKslO4A9XFYBUlTGPuGM6PffkZUMXjMJlL',
          'Figma Store', '${currencySymbol}150.00', 'Oct 27', '3:00 PM', isMobile,
        ),
        SizedBox(height: 12),
        _buildActivityItem(null, 'Local Cafe', '${currencySymbol}12.50', 'Oct 27', '9:15 AM', isMobile, icon: Icons.lunch_dining),
      ],
    );
  }

  Widget _buildActivityItem(String? imageUrl, String title, String amount, String date, String time, bool isMobile, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 36 : 40,
            height: isMobile ? 36 : 40,
            decoration: BoxDecoration(
              color: imageUrl != null ? textPrimary : iconBgDark,
              borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  )
                : Icon(icon ?? Icons.store, color: textPrimary, size: isMobile ? 18 : 20),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textPrimary, fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w600)),
                Text('-$amount', style: TextStyle(color: textSecondary, fontSize: isMobile ? 12 : 14)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date, style: TextStyle(color: textPrimary, fontSize: isMobile ? 10 : 14, fontWeight: FontWeight.w500)),
              Text(time, style: TextStyle(color: textSecondary, fontSize: isMobile ? 10 : 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNav(bool isMobile) {
    return Positioned(
      bottom: isMobile ? 16 : 20,
      left: 20,
      right: 20,
      child: Container(
        height: isMobile ? 56 : 64,
        decoration: BoxDecoration(
          color: surfaceDark.withOpacity(0.9),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10))],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home, 0, isMobile),
                _buildNavItem(Icons.person_outlined, 1, isMobile),
                SizedBox(width: isMobile ? 56 : 64),
                _buildNavItem(Icons.account_balance_wallet_outlined, 3, isMobile),
                _buildNavItem(Icons.settings_outlined, 4, isMobile),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isCenterButtonHovered = true),
                  onExit: (_) => setState(() => _isCenterButtonHovered = false),
                  child: GestureDetector(
                    onTap: () => print('Center button tapped'),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: isMobile ? 56 : 64,
                      height: isMobile ? 56 : 64,
                      margin: EdgeInsets.only(bottom: isMobile ? 32 : 40),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [neonPurple.withOpacity(0.9), neonPurple, Color(0xFF8B4CB8)],
                        ),
                        borderRadius: BorderRadius.circular(isMobile ? 28 : 32),
                        border: Border.all(color: backgroundDark, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: neonPurple.withOpacity(_isCenterButtonHovered && !isMobile ? 0.6 : 0.4),
                            blurRadius: _isCenterButtonHovered && !isMobile ? 30 : 20,
                            offset: Offset(0, _isCenterButtonHovered && !isMobile ? 10 : 6),
                            spreadRadius: _isCenterButtonHovered && !isMobile ? 3 : 1,
                          ),
                        ],
                      ),
                      child: Icon(Icons.add_rounded, color: textPrimary, size: isMobile ? 28 : 32),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, bool isMobile) {
    bool isActive = selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedNavIndex = index),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 8 : 12),
        child: Icon(icon, color: isActive ? neonPurple : textSecondary, size: isMobile ? 20 : 24),
      ),
    );
  }
}