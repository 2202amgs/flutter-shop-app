import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/shop/cubit/cubit.dart';
import 'package:shop_app/layouts/shop/cubit/staties.dart';
import 'package:shop_app/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutState>(
      listener: (context, state) {},
      builder: (context, state) => ListView.separated(
        itemBuilder: (context, index) => categoriesItem(
            ShopLayoutCubit.get(context).categoriesData!.allData!.data![index]),
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 2,
              color: Colors.grey,
            ),
          );
        },
        itemCount:
            ShopLayoutCubit.get(context).categoriesData!.allData!.data!.length,
      ),
    );
  }

  Widget categoriesItem(CategoriesDataModel model) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            width: 100,
            height: 100,
            image: NetworkImage(model.image!),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(model.name!),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
