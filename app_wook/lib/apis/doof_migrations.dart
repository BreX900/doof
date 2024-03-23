import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/core/logger.dart';
import 'package:mek_gasol/shared/data/r.dart';

class DoofDatabaseMigrations {
  static const organizationId = Env.organizationId;

  static DoofDatabaseMigrations get instance => DoofDatabaseMigrations._();

  FirebaseAuth get _auth => Instances.auth;
  FirebaseFirestore get _firestore => Instances.firestore;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  DoofDatabaseMigrations._();

  Future<void> createCart() async {
    await _firestore
        .collection(OrganizationsRepository.collection)
        .doc(Env.organizationId)
        .collection(CartsRepository.collection)
        .withJsonConverter(CartDto.fromJson)
        .doc(Env.cartId)
        .set(CartDto(
          id: Env.cartId,
          ownerId: _auth.currentUser!.uid,
          membersIds: const IListConst([]),
          isPublic: true,
          title: 'Kuama',
        ));
    lg.config('Kuama cart created!');
  }

  Future<void> migrateMenu() async {
    lg.config('Database Updating!');

    const wookCollection = '${OrganizationsRepository.collection}/${Env.organizationId}';
    await _elaborate('Database Cleaning!', [
      _cleanCollections({
        '$wookCollection/${CategoriesRepository.collection}': <String, dynamic>{},
        '$wookCollection/${ProductsRepository.collection}': <String, dynamic>{},
        '$wookCollection/${IngredientsRepository.collection}': <String, dynamic>{},
        '$wookCollection/${LevelsRepository.collection}': <String, dynamic>{},
      })
    ]);
    lg.config('Database Cleaned!');

    const firstCoursesCategory = CategoryDto(
      id: 'qis6JTiLNl0Cdfz2D0Wh',
      weight: 0,
      title: 'Primi Piatti',
    );
    const ravioliCategory = CategoryDto(
      id: '1hbbRQVurQwZ7JSAu19Z',
      weight: 1,
      title: 'Ravioli',
    );
    const drinksCategory = CategoryDto(
      id: 'J5IU4RRi5Dy5EHyfkSNL',
      weight: 2,
      title: 'Bevande',
    );
    const categories = [firstCoursesCategory, ravioliCategory, drinksCategory];

    final ingredients = [
      IngredientDto(
        id: 'koyuDvKDhL1imLcgjHr5',
        title: 'Pollo',
        description: 'Aggiunta di pollo',
        price: Decimal.parse('1.60'),
      ),
      IngredientDto(
        id: 'VEI2ub9FOosr2GK6jMMc',
        title: 'Maiale',
        description: 'Aggiunta di maiale',
        price: Decimal.parse('1.60'),
      ),
      IngredientDto(
        id: 'DsqZgv5vO6fKmk2e0pYV',
        title: 'Manzo',
        description: 'Pezzettini di manzo saltati in padella.',
        price: Decimal.parse('1.90'),
      ),
      IngredientDto(
        id: 'J4XU2yRjpaTzYzNLTRRM',
        title: 'Gamberetti',
        description: 'Aggiunta di gamberetti',
        price: Decimal.parse('1.90'),
      ),
      IngredientDto(
        id: 'MV0JieRZm6GREnaUM7Ip',
        title: 'Uovo Extra',
        description: 'Aggiunta di un uovo strapazzato',
        price: Decimal.parse('0.80'),
      ),
      IngredientDto(
        id: 'Dw50GWoFNGuIxc1N7sMB',
        title: 'Zucchine Extra',
        description: 'Aggiunta di una porzione di zucchine',
        price: Decimal.parse('0.60'),
      ),
      IngredientDto(
        id: '98L1YkegtKjBi1fXPY1d',
        title: 'Carote Extra',
        description: 'Aggiunta di una porzione di carote',
        price: Decimal.parse('0.60'),
      ),
      IngredientDto(
        id: 'fL6SSIIhwD5CZ7C2Httd',
        title: 'Cavolo Extra',
        description: 'Aggiunta di una porzione di cavolo',
        price: Decimal.parse('0.60'),
      ),
    ];

    const levels = [
      LevelDto(
        id: 'MYfBAEtoVzUrFQQLFxyP',
        title: 'Salsa Di Soia',
        description: '',
        min: 0,
        initial: 0,
        max: 4,
      ),
      LevelDto(
        id: 'AJaYFe7rBgt3cODa0Yec',
        title: 'Salsa Piccante',
        description: '',
        min: 0,
        initial: 0,
        max: 4,
      ),
    ];

    final productIngredients = ingredients.map((e) => e.id).toIList();
    final productLevels = levels.map((level) => level.id).toIList();

    final firstCourses = [
      ProductDto(
        id: '2CEsGXmUT6GcDMhKHD7C',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage('2CEsGXmUT6GcDMhKHD7C', R.firstCoursesSpaghettiUovo),
        title: "Spaghetti all'uovo",
        description: "Spaghetti all'uovo saltati con uova e verdure di stagione.",
        price: Decimal.parse('4.50'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: productIngredients,
        levels: productLevels,
      ),
      ProductDto(
        id: 'eCO73liFjEGHEvIaF8QL',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage('eCO73liFjEGHEvIaF8QL', R.firstCoursesSpaghettiUdon),
        title: 'Spaghetti Udon',
        description: 'Spaghetti udon saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.50'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: productIngredients,
        levels: productLevels,
      ),
      ProductDto(
        id: 'OU54VLbMSMRnMEIme0nu',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage('OU54VLbMSMRnMEIme0nu', R.firstCoursesGnocchiRiso),
        title: 'Gnocchi Di Riso',
        description: 'Gnocchi di riso saltati con uova e verdure di stagione.',
        price: Decimal.parse('4.50'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: productIngredients,
        levels: productLevels,
      ),
      ProductDto(
        id: 'KFdKDYCv5CrdEkMPlPPY',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage('KFdKDYCv5CrdEkMPlPPY', R.firstCoursesRisoCantonese),
        title: 'Riso Alla Cantonese',
        description: 'Riso saltato con uova, prosciutto cotto e piselli.',
        price: Decimal.parse('4.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: productIngredients,
        levels: productLevels,
      ),
      ProductDto(
        id: 'eOuccbWyv3hXdaQTCUxm',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage('eOuccbWyv3hXdaQTCUxm', R.firstCoursesRisoVerdureMiste),
        title: 'Riso Con Verdure Miste',
        description: 'Riso saltato con uova, carote, zucchine e piselli.',
        price: Decimal.parse('4.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: productIngredients,
        levels: productLevels,
      ),
      ProductDto(
        id: 'tGVLMvzKY8FpgirYVK6P',
        categoryId: firstCoursesCategory.id,
        imageUrl: await _uploadProductImage('tGVLMvzKY8FpgirYVK6P', R.firstCoursesRisoGamberetti),
        title: 'Riso Con Gamberetti',
        description: 'Riso saltato con uova, piselli e gamberetti.',
        price: Decimal.parse('4.80'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: productIngredients,
        levels: productLevels,
      ),
    ];

    final ravioli = [
      ProductDto(
        id: 'tIGXj4JPigpru7r1HTqT',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage('tIGXj4JPigpru7r1HTqT', R.ravioliRavioliVerdure),
        title: 'Ravioli Con Verdure',
        description: 'Ravioli al vapore con ripieno alle verdure (6 pz).',
        price: Decimal.parse('3.90'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: '3ED7ABZLejHEwVx5d9GU',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage('3ED7ABZLejHEwVx5d9GU', R.ravioliRavioliCarne),
        title: 'Ravioli Di Carne',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.90'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'n2MHLI4GfWCfPauCpigP',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage('n2MHLI4GfWCfPauCpigP', R.ravioliRavioliXiaoLongBao),
        title: 'Xiao Long Bao',
        description: 'Ravioli al vapore con ripieno alla carne di maiale (6 pz).',
        price: Decimal.parse('3.90'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'B8paUtP7m1p2LeVI9pAG',
        categoryId: ravioliCategory.id,
        imageUrl: await _uploadProductImage('B8paUtP7m1p2LeVI9pAG', R.ravioliRavioliGamberi),
        title: 'Shao Mai',
        description: 'Ravioli al vapore con ripieno ai gamberetti (6 pz).',
        price: Decimal.parse('4.60'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
    ];

    final drinks = [
      ProductDto(
        id: 'vBTp1rEYs444Tj7Rp2pv',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Acqua Naturale',
        description: 'Bottiglietta da 0.5L.',
        price: Decimal.parse('1.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'rFrsKjDdzI0HVTGruZKQ',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Acqua Frizzante',
        description: 'Bottiglietta da 0.5L.',
        price: Decimal.parse('1.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'Ng4gG1hAu2Be2ws87D9P',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Té Al Limone',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: '2CRDqwzWc9uDcgGqIyD0',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Té Alla Pesca',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'ymvsXJXFNSaFcirWYrlK',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Fanta',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'ePrNHHRjEulf10QBNo6F',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Coca Cola',
        description: 'Lattina da 33cl.',
        price: Decimal.parse('1.50'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'fnIvuAG2yH50MrT9IL4w',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Redbull',
        description: 'Lattina da 25cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'LLrvqplltLs85UiGAkSw',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Birra Moretti',
        description: 'Bottiglia da 66cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: 'YKMFDOi5dBCQ7NSMM1mF',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Birra Ichnusa',
        description: 'Bottiglia da 50cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
      ProductDto(
        id: '9oik8asfD96W5JMUNzfL',
        categoryId: drinksCategory.id,
        imageUrl: null,
        title: 'Birra Tsingtao',
        description: 'Bottiglia da 64cl.',
        price: Decimal.parse('3.00'),
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
    ];
    await Future.wait([
      _elaborate('Updating: Categories', categories.map((e) {
        return CategoriesRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: First Courses', firstCourses.map((e) {
        return ProductsRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: Ingredients', ingredients.map((e) {
        return IngredientsRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: Levels', levels.map((e) {
        return LevelsRepository.instance.save(organizationId, e);
      })),
      _elaborate('Updating: Ravioli', ravioli.map((e) {
        return ProductsRepository.instance.upsert(organizationId, e);
      })),
      _elaborate('Updating: Drinks', drinks.map((e) {
        return ProductsRepository.instance.upsert(organizationId, e);
      })),
    ]);
    lg.config('Database Updated!');
  }

  Future<void> deleteCartsOrders() async {
    // Delete user data database
    lg.config('Database Deleting...');
    await _cleanCollections({
      CartsRepository.collection: {CartItemsRepository.collection: null},
      OrdersRepository.collection: {OrderItemsRepository.collection: null}
    });
    lg.config('Database Deleted!');
  }

  Future<void> _cleanCollections(Map<dynamic, dynamic> collections, {String? doc}) async {
    await Future.wait(collections.entries.mapTo((collection, subCollections) async {
      final collectionRef = doc != null
          ? _firestore.doc(doc).collection(collection)
          : _firestore.collection(collection);

      final docs = await collectionRef.get();

      await Future.wait(docs.docs.map((doc) async {
        if (subCollections is Map) await _cleanCollections(subCollections, doc: doc.reference.path);

        await doc.reference.delete();
      }));
      lg.config('  ✅ ${collectionRef.path}');
    }));
  }

  Future<void> _elaborate(String name, Iterable<Future<void>> futures) async {
    lg.config(name);
    await Future.wait(futures);
  }

  Future<String> _uploadProductImage(String productId, String assetId) async {
    final data = await rootBundle.load(assetId);
    final snapshot = await _storage
        .ref('${Env.mode}/products/$productId/${assetId.split('/').last}')
        .putData(data.buffer.asUint8List());
    return await snapshot.ref.getDownloadURL();
  }
}
