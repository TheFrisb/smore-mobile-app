import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/models/user_subscription.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/subscriptions/billing_toggle.dart';
import '../components/subscriptions/plan_card.dart';
import '../components/subscriptions/summary_section.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../service/dio_client.dart';

class ManagePlanScreen extends StatefulWidget {
  const ManagePlanScreen({super.key});

  @override
  State<ManagePlanScreen> createState() => _ManagePlanScreenState();
}

class _ManagePlanScreenState extends State<ManagePlanScreen> {
  static final Logger _logger = Logger();

  bool _isYearly = false;
  bool _isLoading = true;
  List<Product> _products = [];
  Set<int> _selectedProductIds = {};

  Future<void> _launchManagePlanUrl() async {
    const url = 'https://smoreltd.com/accounts/manage-plan/';
    Uri uriResource = Uri.parse(url);
    if (!await launchUrl(uriResource, mode: LaunchMode.externalApplication)) {
      _logger.e("Failed to launch url: $url");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _setInitialState();
  }

  void _setInitialState() {
    UserSubscription? userSubscription =
        Provider.of<UserProvider>(context, listen: false)
            .user
            ?.userSubscription;

    if (userSubscription == null) {
      _logger.i('No user subscription found.');
      return;
    }

    _isYearly = !userSubscription.isMonthly;

    _selectedProductIds =
        userSubscription.products.map((product) => product.id).toSet();

    _logger.i(
      'Initial state set: isYearly: $_isYearly, selectedProductIds: $_selectedProductIds',
    );
  }

  double _getProductSalePrice(Product product) {
    bool isMonthly = !_isYearly;

    double salePrice = product.getSalePrice(isMonthly, false);
    _logger.i(
      'Product ID: ${product.id}, Sale Price: $salePrice, Is Monthly: $isMonthly',
    );

    if (isMonthly) {
      return salePrice;
    } else {
      return salePrice / 12;
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = DioClient().dio;
      final response = await dio.get('/products');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        setState(() {
          _products = data.map((json) => Product.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStripeSubscriptionMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Enhanced icon container with better gradient and shadow
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.3),
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.payment_rounded,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            // Enhanced main title with gradient text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'Stripe Subscription',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // Enhanced subtitle
            const Text(
              'You are subscribed through Stripe',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFdbe4ed),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Enhanced description container with better styling
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0D151E).withOpacity(0.8),
                    const Color(0xFF0D151E).withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please manage your subscription from our website',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFdbe4ed),
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _launchManagePlanUrl,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Visit Website',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackButtonScreen(
      padding: const EdgeInsets.only(left: 16, right: 16),
      title: "Manage Plan",
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final User? user = userProvider.user;
          final UserSubscription? userSubscription =
              userProvider.user?.userSubscription;
          if (user == null) {
            return const Center(
              child: Text(
                'No user data available. This is most likely a bug in the application. Please contact support.',
              ),
            );
          }

          if (userSubscription != null &&
              userSubscription.providerType ==
                  SubscriptionProviderType.STRIPE) {
            return _buildStripeSubscriptionMessage(context);
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        BillingToggle(
                          isYearly: _isYearly,
                          onChanged: (value) {
                            setState(() {
                              _isYearly = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _products[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: PlanCard(
                            key: ValueKey(product.id),
                            // Unique key for each PlanCard
                            product: product,
                            isYearly: _isYearly,
                            isSelected:
                                _selectedProductIds.contains(product.id),
                            onSelected: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedProductIds.add(product.id);
                                } else {
                                  _selectedProductIds.remove(product.id);
                                }
                              });
                            },
                          ),
                        );
                      },
                      childCount: _products.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // Replaced SliverToBoxAdapter
                        SummarySection(
                          selectedProducts: _products
                              .where((p) => _selectedProductIds.contains(p.id))
                              .toList(),
                          isYearly: _isYearly,
                          onSubscribe: () {
                            _logger.i(
                              'Subscribe to ${_selectedProductIds.map((id) => _products.firstWhere((p) => p.id == id).name).join(', ')}',
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}
