// auth_pages.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';

// Authentication Wrapper
class AuthWrapper extends StatefulWidget {
  final Function(String, String) onAuthComplete; // (userName, currency)
  
  AuthWrapper({required this.onAuthComplete});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLogin = true;
  bool showOnboarding = false;
  String userName = '';

  void _handleLogin(String name) {
    setState(() {
      userName = name;
      showOnboarding = true;
    });
  }

  void _handleOnboardingComplete(String currency) {
    widget.onAuthComplete(userName, currency);
  }

  @override
  Widget build(BuildContext context) {
    if (showOnboarding) {
      return OnboardingPage(
        userName: userName,
        onComplete: _handleOnboardingComplete,
      );
    }
    
    return isLogin 
      ? LoginPage(
          onSwitchToSignup: () => setState(() => isLogin = false),
          onLogin: _handleLogin,
        )
      : SignupPage(
          onSwitchToLogin: () => setState(() => isLogin = true),
          onSignup: _handleLogin,
        );
  }
}

// ONBOARDING PAGE
class OnboardingPage extends StatefulWidget {
  final String userName;
  final Function(String) onComplete;
  
  OnboardingPage({required this.userName, required this.onComplete});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  String selectedCurrency = 'USD';
  bool _isContinueButtonHovered = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Colors
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color neonPurple = Color(0xFFBF5AF2);

  final List<Map<String, String>> currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'symbol': '¥'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'symbol': 'C\$'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'symbol': 'A\$'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'symbol': 'CHF'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'symbol': '¥'},
    {'code': 'INR', 'name': 'Indian Rupee', 'symbol': '₹'},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    
    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 400,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60),
                      _buildLogo(),
                      SizedBox(height: 60),
                      _buildWelcomeMessage(isMobile),
                      SizedBox(height: 40),
                      _buildCurrencySelector(isMobile),
                      SizedBox(height: 40),
                      _buildContinueButton(isMobile),
                      SizedBox(height: 20),
                      _buildSkipLink(isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: neonPurple.withOpacity(0.4),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/duolingo.gif', // Add this GIF to your assets folder
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi ${widget.userName}! 👋',
          style: TextStyle(
            fontSize: isMobile ? 32 : 36,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Welcome to Power Shopper! Let\'s get you set up with your preferred currency for the best shopping experience.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencySelector(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Currency',
          style: TextStyle(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              dropdownColor: surfaceDark,
              icon: Icon(Icons.keyboard_arrow_down, color: textSecondary),
              style: TextStyle(color: textPrimary, fontSize: isMobile ? 16 : 18),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCurrency = newValue;
                  });
                }
              },
              items: currencies.map<DropdownMenuItem<String>>((currency) {
                return DropdownMenuItem<String>(
                  value: currency['code'],
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: neonPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            currency['symbol']!,
                            style: TextStyle(
                              color: neonPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currency['name']!,
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              currency['code']!,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: isMobile ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isContinueButtonHovered = true),
      onExit: (_) => setState(() => _isContinueButtonHovered = false),
      child: GestureDetector(
        onTap: () {
          print('Selected currency: $selectedCurrency');
          widget.onComplete(selectedCurrency);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: double.infinity,
          height: isMobile ? 52 : 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                neonPurple.withOpacity(_isContinueButtonHovered ? 1.0 : 0.9),
                Color(0xFF8B4CB8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: neonPurple.withOpacity(_isContinueButtonHovered ? 0.5 : 0.3),
                blurRadius: _isContinueButtonHovered ? 25 : 15,
                offset: Offset(0, _isContinueButtonHovered ? 8 : 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Continue to Dashboard',
              style: TextStyle(
                color: textPrimary,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipLink(bool isMobile) {
    return Center(
      child: GestureDetector(
        onTap: () {
          print('Skipped currency selection, using USD');
          widget.onComplete('USD');
        },
        child: Text(
          'Skip for now',
          style: TextStyle(
            color: textSecondary,
            fontSize: isMobile ? 14 : 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

// LOGIN PAGE
class LoginPage extends StatefulWidget {
  final VoidCallback onSwitchToSignup;
  final Function(String) onLogin;
  
  LoginPage({required this.onSwitchToSignup, required this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoginButtonHovered = false;
  bool _isGoogleButtonHovered = false;
  bool _isAppleButtonHovered = false;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color neonPurple = Color(0xFFBF5AF2);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _extractNameFromEmail(String email) {
    if (email.contains('@')) {
      String name = email.split('@')[0];
      return name.isNotEmpty ? name[0].toUpperCase() + name.substring(1) : 'User';
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 400,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    _buildHeader(isMobile),
                    SizedBox(height: 40),
                    _buildWelcomeText(isMobile),
                    SizedBox(height: 32),
                    _buildLoginForm(isMobile),
                    SizedBox(height: 24),
                    _buildLoginButton(isMobile),
                    SizedBox(height: 24),
                    _buildDivider(),
                    SizedBox(height: 24),
                    _buildSocialButtons(isMobile),
                    SizedBox(height: 32),
                    _buildSignupLink(isMobile),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [neonPurple, Color(0xFF8B4CB8)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: neonPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: textPrimary,
            size: 28,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Power Shopper',
          style: TextStyle(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: isMobile ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sign in to your account to continue shopping',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          isMobile: isMobile,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_outline,
          isPassword: true,
          isMobile: isMobile,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (value) => setState(() => _rememberMe = value!),
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return neonPurple;
                      }
                      return Colors.transparent;
                    }),
                    side: BorderSide(color: textSecondary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Remember me',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () => print('Forgot password tapped'),
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: neonPurple,
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textPrimary,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            style: TextStyle(
              color: textPrimary,
              fontSize: isMobile ? 14 : 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: textSecondary),
              prefixIcon: Icon(icon, color: textSecondary),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isMobile) {
    return NeoPopTiltedButton(
      isFloating: true,
      onTapUp: () {
        String name = _extractNameFromEmail(_emailController.text);
        print('Login attempted with: ${_emailController.text}, extracted name: $name');
        widget.onLogin(name);
      },
      decoration: NeoPopTiltedButtonDecoration(
        color: neonPurple, // Main button color (purple)
        plunkColor: Color(0xFF8B4CB8), // Slightly darker purple for plunk
        shadowColor: Color(0xFF808080),
        showShimmer: true,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF6C3483), width: 1.5), // Darker purple border
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 140.0, vertical: 12),
        child: Text(
          'Sign In',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: textSecondary.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: textSecondary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            label: 'Google',
            icon: Icons.g_mobiledata,
            isHovered: _isGoogleButtonHovered,
            onHover: (hovered) => setState(() => _isGoogleButtonHovered = hovered),
            onTap: () {
              print('Google login tapped');
              widget.onLogin('Google User');
            },
            isMobile: isMobile,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSocialButton(
            label: 'Apple',
            icon: Icons.apple,
            isHovered: _isAppleButtonHovered,
            onHover: (hovered) => setState(() => _isAppleButtonHovered = hovered),
            onTap: () {
              print('Apple login tapped');
              widget.onLogin('Apple User');
            },
            isMobile: isMobile,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required bool isHovered,
    required Function(bool) onHover,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: isMobile ? 48 : 52,
          decoration: BoxDecoration(
            color: isHovered ? surfaceDark.withOpacity(0.8) : surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered ? neonPurple.withOpacity(0.5) : Colors.white.withOpacity(0.1),
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: neonPurple.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isHovered ? neonPurple : textPrimary,
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isHovered ? neonPurple : textPrimary,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupLink(bool isMobile) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
              color: textSecondary,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          GestureDetector(
            onTap: widget.onSwitchToSignup,
            child: Text(
              'Sign up',
              style: TextStyle(
                color: neonPurple,
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SIGNUP PAGE
class SignupPage extends StatefulWidget {
  final VoidCallback onSwitchToLogin;
  final Function(String) onSignup;
  
  SignupPage({required this.onSwitchToLogin, required this.onSignup});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isSignupButtonHovered = false;
  bool _isGoogleButtonHovered = false;
  bool _isAppleButtonHovered = false;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color neonPurple = Color(0xFFBF5AF2);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 400,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    _buildHeader(isMobile),
                    SizedBox(height: 40),
                    _buildWelcomeText(isMobile),
                    SizedBox(height: 32),
                    _buildSignupForm(isMobile),
                    SizedBox(height: 24),
                    _buildNeoPopSignupButton(isMobile),
                    SizedBox(height: 24),
                    _buildDivider(),
                    SizedBox(height: 24),
                    _buildSocialButtons(isMobile),
                    SizedBox(height: 32),
                    _buildLoginLink(isMobile),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [neonPurple, Color(0xFF8B4CB8)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: neonPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: textPrimary,
            size: 28,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Power Shopper',
          style: TextStyle(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: isMobile ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sign up to start your shopping journey',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          icon: Icons.person_outline,
          isMobile: isMobile,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          isMobile: isMobile,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_outline,
          isPassword: true,
          obscureText: _obscurePassword,
          onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
          isMobile: isMobile,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          icon: Icons.lock_outline,
          isPassword: true,
          obscureText: _obscureConfirmPassword,
          onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          isMobile: isMobile,
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _agreeToTerms,
                onChanged: (value) => setState(() => _agreeToTerms = value!),
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return neonPurple;
                  }
                  return Colors.transparent;
                }),
                side: BorderSide(color: textSecondary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: isMobile ? 12 : 14,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: neonPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: neonPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textPrimary,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
              color: textPrimary,
              fontSize: isMobile ? 14 : 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: textSecondary),
              prefixIcon: Icon(icon, color: textSecondary),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: textSecondary,
                      ),
                      onPressed: onToggleObscure,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  // NeoPop signup button with app color scheme (purple) and darker purple border
  Widget _buildNeoPopSignupButton(bool isMobile) {
    return NeoPopTiltedButton(
      isFloating: true,
      onTapUp: () {
        if (_passwordController.text != _confirmPasswordController.text) {
          print('Passwords do not match');
          return;
        }
        if (!_agreeToTerms) {
          print('Must agree to terms');
          return;
        }
        String name = _nameController.text.isNotEmpty ? _nameController.text : 'User';
        print('Signup attempted with name: $name');
        widget.onSignup(name);
      },
      decoration: NeoPopTiltedButtonDecoration(
        color: neonPurple, // Main button color (purple)
        plunkColor: Color(0xFF8B4CB8), // Slightly darker purple for plunk
        shadowColor: Color(0xFF808080),
        showShimmer:true,
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFF6C3483), width: 1.5), // Darker purple border
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 140.0, vertical: 12),
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: isMobile ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: textSecondary.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or sign up with',
            style: TextStyle(
              color: textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: textSecondary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            label: 'Google',
            icon: Icons.g_mobiledata,
            isHovered: _isGoogleButtonHovered,
            onHover: (hovered) => setState(() => _isGoogleButtonHovered = hovered),
            onTap: () {
              print('Google signup tapped');
              widget.onSignup('Google User');
            },
            isMobile: isMobile,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSocialButton(
            label: 'Apple',
            icon: Icons.apple,
            isHovered: _isAppleButtonHovered,
            onHover: (hovered) => setState(() => _isAppleButtonHovered = hovered),
            onTap: () {
              print('Apple signup tapped');
              widget.onSignup('Apple User');
            },
            isMobile: isMobile,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required bool isHovered,
    required Function(bool) onHover,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: isMobile ? 48 : 52,
          decoration: BoxDecoration(
            color: isHovered ? surfaceDark.withOpacity(0.8) : surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered ? neonPurple.withOpacity(0.5) : Colors.white.withOpacity(0.1),
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: neonPurple.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isHovered ? neonPurple : textPrimary,
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isHovered ? neonPurple : textPrimary,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(bool isMobile) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              color: textSecondary,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          GestureDetector(
            onTap: widget.onSwitchToLogin,
            child: Text(
              'Sign in',
              style: TextStyle(
                color: neonPurple,
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
