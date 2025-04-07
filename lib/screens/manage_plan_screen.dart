import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:smore_mobile_app/models/user_subscription.dart';
import 'package:smore_mobile_app/screens/base/base_back_button_screen.dart';

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
  int? firstSelectedProductId;

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

    firstSelectedProductId = userSubscription.firstChosenProduct.id;

    _logger.i(
      'Initial state set: isYearly: $_isYearly, selectedProductIds: $_selectedProductIds, firstSelectedProductId: $firstSelectedProductId',
    );
  }

  double _getProductSalePrice(Product product) {
    bool useDiscount = false;

    if (_selectedProductIds.length > 1 &&
        product.id != firstSelectedProductId) {
      useDiscount = true;
    }

    bool isMonthly = !_isYearly;

    double salePrice = product.getSalePrice(isMonthly, useDiscount);
    _logger.i(
      'Product ID: ${product.id}, Sale Price: $salePrice, Is Monthly: $isMonthly, Use Discount: $useDiscount',
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
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'You are subscribed through Stripe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Please manage your subscription from our website.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ));
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
                            showDiscount: () {
                              if (_selectedProductIds.isNotEmpty &&
                                  product.id != firstSelectedProductId) {
                                return true;
                              }
                              return false;
                            }(),
                            onSelected: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedProductIds.add(product.id);

                                  firstSelectedProductId ??= product.id;
                                } else {
                                  _selectedProductIds.remove(product.id);

                                  if (product.id == firstSelectedProductId) {
                                    if (_selectedProductIds.isNotEmpty) {
                                      firstSelectedProductId =
                                          _selectedProductIds.first;
                                    } else {
                                      firstSelectedProductId = null;
                                    }
                                  }
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
                          firstSelectedProductId: firstSelectedProductId,
                          useDiscountedPrices: () {
                            if (_selectedProductIds.length > 1) {
                              return true;
                            }
                            return false;
                          }(),
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
