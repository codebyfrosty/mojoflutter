import 'package:flutter/material.dart';
import 'package:flutter_ar/constant/api.dart';
import 'package:flutter_ar/provider/wishlist_provider.dart';
import 'package:flutter_ar/shared/fav_card.dart';
import 'package:flutter_ar/shared/theme.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<WishProvider>(context, listen: false).fetchWishData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Favorite',
          style: boldTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<WishProvider>(
                builder: (context, state, _) {
                  if (state.wishStatus == WishStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.wishStatus == WishStatus.empty) {
                    return const Center(
                        child: Text('You dont have any wishlist yet'));
                  } else if (state.wishStatus == WishStatus.error) {
                    return const Center(
                        child:
                            Text('Error fetching wish data, please try again'));
                  } else {
                    return ListView.builder(
                      itemCount: state.wishItems.length,
                      itemBuilder: (context, index) {
                        return FavCard(
                          onDelete: () {
                            Provider.of<WishProvider>(context, listen: false)
                                .deleteCartItem(state.wishItems[index].sku);
                          },
                          wishModel: state.wishItems[index],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
