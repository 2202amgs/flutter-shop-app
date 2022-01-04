import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/cubit/cubit.dart';
import 'package:shop_app/layouts/shop/cubit/staties.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/components/global_components.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutState>(
      listener: (context, state) {
        if (state is ShopLayoutSuccessChangeFavouritesState &&
            !state.changeFavouriteModel.status!) {
          toast(context, state.changeFavouriteModel.message!,
              color: Colors.red);
        } else if (state is ShopLayoutErrorChangeFavouritesState) {
          toast(context, "Connection Error", color: Colors.red);
        }
      },
      builder: (context, state) {
        ShopLayoutCubit cubit = ShopLayoutCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeData != null && cubit.categoriesData != null,
          builder: (context) => productsBuilderItems(
              context, cubit.homeData!, cubit.categoriesData!.allData),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

// Category Widget
  Widget categoeyBuilderItems(CategoriesAllDataModel? model) {
    ScrollController scrollController = ScrollController();
    return SizedBox(
      height: 100.0,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => categoryItem(model!.data![index]),
        separatorBuilder: (context, index) => const SizedBox(
          width: 20,
        ),
        itemCount: model!.data!.length,
      ),
    );
  }

  Widget categoryItem(CategoriesDataModel? model) {
    ImageProvider image;

    try {
      image = NetworkImage(model!.image.toString());
    } catch (e) {
      image = const AssetImage('assets/images/no.jpg');
    }
    return SizedBox(
      height: 100.0,
      width: 100.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: image,
            width: 100,
            height: 100,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            width: double.infinity,
            color: Colors.black.withOpacity(0.7),
            child: Text(
              '${model!.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

// Products Widget
  Widget productsBuilderItems(
          context, HomeModel? model, CategoriesAllDataModel? categoriesModel) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model!.data!.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 200.0,
                enableInfiniteScroll: true, // يلف حوالي نفسه
                initialPage: 0,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.elasticIn,
                viewportFraction: 1, // حجم الصورة
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  categoeyBuilderItems(categoriesModel),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.91,
              children: model.data!.products
                  .map((e) => buildGridProducts(context, e))
                  .toList(),
            ),
          ],
        ),
      );

  Widget buildGridProducts(context, ProductModel model) {
    ImageProvider img;
    try {
      img = NetworkImage('${model.image}');
    } catch (error) {
      img = const AssetImage('assets/images/not.jpg');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: img,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.contain,
            ),
            if (model.discount!.toDouble() > 0)
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
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name.toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 1.3,
                ),
              ),
              Row(
                children: [
                  Text(
                    '\$${model.price}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  if (model.discount!.toDouble() > 0)
                    Text(
                      '\$${model.oldPrice}',
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
                      ShopLayoutCubit.get(context).changeFoavourites(model.id!);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color:
                          favourites[model.id!]! ? Colors.red : Colors.blueGrey,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
