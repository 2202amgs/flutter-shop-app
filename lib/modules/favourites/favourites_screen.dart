import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/cubit/cubit.dart';
import 'package:shop_app/layouts/shop/cubit/staties.dart';
import 'package:shop_app/models/FavouritesModel.dart';
import 'package:shop_app/shared/components/constance.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopLayoutCubit.get(context);
          return ConditionalBuilder(
            condition: state is ShopLayoutLoadingFavouritesState,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            fallback: (context) => ConditionalBuilder(
              condition:
                  favouritesModel != null && favouritesModel!.allData != null,
              builder: (context) => ListView.separated(
                itemBuilder: (context, index) => buildFavItem(
                    context, favouritesModel!.allData!.data![index]),
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  );
                },
                itemCount: favouritesModel!.allData!.data!.length,
              ),
              fallback: (context) => const Center(
                child: Text(
                  'Fvourites List Is Empty !!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget buildFavItem(context, Data model) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.product!.image.toString()),
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.fill,
                ),
                if (model.product!.discount!.toDouble() > 0)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.product!.name.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '\$${model.product!.price}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (model.product!.discount!.toDouble() > 0)
                        Text(
                          '\$${model.product!.oldPrice}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        onPressed: () {
                          ShopLayoutCubit.get(context)
                              .changeFoavourites(model.product!.id!);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
