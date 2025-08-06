import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smore_mobile_app/service/revenuecat_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/purchases/subscription_button.dart';
import '../components/purchases/subscription_option_card.dart';
import '../models/product.dart';
import '../providers/user_provider.dart';
import '../service/dio_client.dart';

class TabbedPlanView extends StatefulWidget {
  const TabbedPlanView({super.key});

  @override
  State<TabbedPlanView> createState() => _TabbedPlanViewState();
}

class _TabbedPlanViewState extends State<TabbedPlanView>
    with SingleTickerProviderStateMixin {
  static final Logger _logger = Logger();

  late TabController _tabController;
  bool _isLoading = true;
  String _selectedSubscription = 'yearly';

  late List<Product> _products;

  Offering? _soccerOfferings;
  Offering? _basketballOfferings;
  Offering? _aiAnalystOfferings;

  final List<ProductName> _tabCategories = [
    ProductName.SOCCER,
    ProductName.BASKETBALL,
    ProductName.AI_ANALYST,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _fetchProducts();
    _fetchOfferings();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Update selected subscription based on available packages in the new tab
    final currentCategory = _tabCategories[_tabController.index];

    Offering? currentOfferings;
    switch (currentCategory) {
      case ProductName.SOCCER:
        currentOfferings = _soccerOfferings;
        break;
      case ProductName.BASKETBALL:
        currentOfferings = _basketballOfferings;
        break;
      case ProductName.AI_ANALYST:
        currentOfferings = _aiAnalystOfferings;
        break;
      case ProductName.NFL_NHL:
      case ProductName.TENNIS:
        return;
    }

    if (currentOfferings != null) {
      // Prefer yearly if available, otherwise monthly
      if (currentOfferings.annual != null) {
        setState(() {
          _selectedSubscription = 'yearly';
        });
      } else if (currentOfferings.monthly != null) {
        setState(() {
          _selectedSubscription = 'monthly';
        });
      }
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Product> response = await DioClient().dio.get('/products').then(
            (response) => (response.data as List)
                .map((item) => Product.fromJson(item))
                .toList(),
          );
      setState(() {
        _products = response;
      });
    } catch (e) {
      _logger.e('Failed to fetch products: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchOfferings() async {
    setState(() {
      _isLoading = true;
    });

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    try {
      userProvider.customerInfo!.entitlements.active
          .forEach((key, entitlement) {
        _logger.i('Active entitlement: $key - ${entitlement.identifier}');
        _logger.i('Product ID: ${entitlement.productIdentifier}');
      });

      // Fetch offerings
      _soccerOfferings = await RevenueCatService()
          .getOffering(SubscriptionIdentifiers.soccer.value);
      _basketballOfferings = await RevenueCatService()
          .getOffering(SubscriptionIdentifiers.basketball.value);
      _aiAnalystOfferings = await RevenueCatService()
          .getOffering(SubscriptionIdentifiers.aiAnalyst.value);
    } catch (e) {
      _logger.e('Failed to fetch offerings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isPackageOwned(Package package, EntitlementPeriod entitlementPeriod) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final customerInfo = userProvider.customerInfo;
    if (customerInfo == null) return false;
    final revenueCatService = RevenueCatService();
    return revenueCatService.customerInfoHasActiveEntitlement(
        customerInfo, package, entitlementPeriod);
  }

  Package? get _selectedPackage {
    final currentCategory = _tabCategories[_tabController.index];

    Offering? currentOfferings;
    switch (currentCategory) {
      case ProductName.SOCCER:
        currentOfferings = _soccerOfferings;
        break;
      case ProductName.BASKETBALL:
        currentOfferings = _basketballOfferings;
        break;
      case ProductName.AI_ANALYST:
        currentOfferings = _aiAnalystOfferings;
        break;
      case ProductName.NFL_NHL:
      case ProductName.TENNIS:
        return null;
    }

    if (currentOfferings == null) return null;

    return _selectedSubscription == 'yearly'
        ? currentOfferings.annual
        : currentOfferings.monthly;
  }

  Future<void> _launchUrl(String url) async {
    Uri uriResource = Uri.parse(url);
    if (!await launchUrl(uriResource, mode: LaunchMode.externalApplication)) {
      _logger.e("Failed to launch url: $url");
    }
  }

  Widget _buildNoOfferingsMessage(ProductName category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.15),
            Colors.grey.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No offerings available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[300],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for ${category.displayName} subscriptions',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProductName category) {
    Package? monthlyPackage;
    Package? yearlyPackage;

    switch (category) {
      case ProductName.SOCCER:
        monthlyPackage = _soccerOfferings?.monthly;
        yearlyPackage = _soccerOfferings?.annual;
        break;
      case ProductName.BASKETBALL:
        monthlyPackage = _basketballOfferings?.monthly;
        yearlyPackage = _basketballOfferings?.annual;
        break;
      case ProductName.AI_ANALYST:
        monthlyPackage = _aiAnalystOfferings?.monthly;
        yearlyPackage = _aiAnalystOfferings?.annual;
        break;
      case ProductName.NFL_NHL:
        throw UnimplementedError();
      case ProductName.TENNIS:
        throw UnimplementedError();
    }

    bool hasOfferings = monthlyPackage != null || yearlyPackage != null;

    Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hasOfferings) ...[
            _buildNoOfferingsMessage(category)
          ] else ...[
            ..._getFeaturesForCategory(category).map(
              (feature) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.checkCheck,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            // Subscription options
            if (yearlyPackage != null)
              SubscriptionOptionCard(
                offeringPackage: yearlyPackage,
                isYearly: true,
                onSelect: () {
                  setState(() {
                    _selectedSubscription = 'yearly';
                  });
                },
                isSelected: _selectedSubscription == 'yearly',
                isOwned:
                    _isPackageOwned(yearlyPackage, EntitlementPeriod.yearly),
              ),

            if (monthlyPackage != null)
              SubscriptionOptionCard(
                offeringPackage: monthlyPackage,
                isYearly: false,
                onSelect: () {
                  setState(() {
                    _selectedSubscription = 'monthly';
                  });
                },
                isSelected: _selectedSubscription == 'monthly',
                isOwned:
                    _isPackageOwned(monthlyPackage, EntitlementPeriod.monthly),
              ),
            const SizedBox(height: 24),
            // Purchase button
            SubscriptionButton(
              selectedPackage: _selectedPackage,
              onSuccess: () {
                _logger.i('Purchase completed successfully');
              },
              onError: () {
                _logger.e('Purchase failed');
                // Handle purchase error - maybe show error message
              },
            ),
            const SizedBox(height: 8),
            // Cancel text
            Center(
              child: Text(
                'You can cancel at any time',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Weak links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      await Purchases.restorePurchases();
                      _logger.i('Purchases restored successfully');
                    } catch (e) {
                      _logger.e('Failed to restore purchases: $e');
                    }
                  },
                  child: Text(
                    'Restore Purchases',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await _launchUrl(
                      'https://smoreltd.com/terms-of-service/',
                    );
                  },
                  child: Text(
                    'Terms',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _logger.i('Privacy pressed');
                    await _launchUrl(
                      'https://smoreltd.com/privacy-policy/',
                    );
                  },
                  child: Text(
                    'Privacy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  List<String> _getFeaturesForCategory(ProductName category) {
    final product = _products.firstWhere(
      (product) => product.name == category,
      orElse: () => _products.first,
    );

    final baseFeatures = switch (category) {
      ProductName.SOCCER || ProductName.BASKETBALL => [
          'Daily Ticket Suggestions',
          'High Odds',
          'Betting Guidance',
          'Promotions & Giveaways',
          '24/7 Client Support',
          'Affiliate Program',
        ],
      ProductName.AI_ANALYST => [
          'AI Bet Builder',
          'Deep Match Analysis',
          'Real-Time News',
          'Tailored Ticket Generator',
        ],
      _ => <String>[],
    };

    return [
      '${product.analysesPerMonth} analyses per month',
      ...baseFeatures,
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        // Pick your plan text
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          child: const Text(
            'Pick your plan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Tab bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D151E),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.grey.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            splashFactory: NoSplash.splashFactory,
            splashBorderRadius: BorderRadius.zero,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: _tabCategories.map((category) {
              return Tab(
                child: Text(
                  category.displayName,
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabCategories.map((category) {
              return _buildTabContent(category);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
