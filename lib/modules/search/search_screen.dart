import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/search_cubit.dart';
import 'package:shop_app/modules/search/cubit/search_states.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/components/global_components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    TextEditingController searchController = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SearchCubit cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Search'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    customTextField(
                      label: 'Search',
                      prefix: const Icon(Icons.search),
                      controller: searchController,
                      type: TextInputType.text,
                      validator: (value) {
                        if (value == null) {
                          return 'Searching word is not found';
                        }
                        return null;
                      },
                      onSubmit: (value) {
                        cubit.getSearchData(word: searchController.text);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (state is SearchGetLoadingState)
                      LinearProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                      condition: cubit.searchModel != null &&
                          searchController.text.isNotEmpty,
                      builder: (context) => Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildSearchItem(
                              context, cubit.searchModel!.allData!.data[index]),
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                height: 2,
                                color: Colors.grey,
                              ),
                            );
                          },
                          itemCount: cubit.searchModel!.allData!.data.length,
                        ),
                      ),
                      fallback: (context) => const Expanded(
                        child: Center(
                          child: Icon(
                            Icons.storage,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchItem(context, Product product) {
    return Container(
      height: 120,
      width: double.infinity,
      child: Row(
        children: [
          Image(
            image: NetworkImage(product.image!),
            height: 120,
            width: 120,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name!),
                const Spacer(),
                Row(
                  children: [
                    Text(product.price.toString()),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: () {
                        SearchCubit.get(context).changeFoavourites(product.id!);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color:
                            favourites[product.id!]! ? Colors.red : Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
