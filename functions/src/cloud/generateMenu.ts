import { firestore } from "../lib/instances";
import { https } from "firebase-functions";
import { ProductDto, Serializers } from "../lib/dto";
import Decimal from "decimal.js";

export const generateMenu = https.onCall(async (request) => {
  const productsRef = firestore.collection("products");

  const products = await productsRef.get();
  await Promise.all(products.docs.map((e) => e.ref.delete()));

  const firstCourses: ReadonlyArray<ProductDto> = [
    {
      id: "2CEsGXmUT6GcDMhKHD7C",
      title: "Spaghetti all'uovo",
      description: "Spaghetti all'uovo saltati con uova e verdure di stagione.",
      price: new Decimal("4.10"),
    },
    {
      id: "eCO73liFjEGHEvIaF8QL",
      title: "Spaghetti Udon",
      description: "Spaghetti udon saltati con uova e verdure di stagione.",
      price: new Decimal("4.10"),
    },
    {
      id: "OU54VLbMSMRnMEIme0nu",
      title: "Gnocchi Di Riso",
      description: "Gnocchi di riso saltati con uova e verdure di stagione.",
      price: new Decimal("4.10"),
    },
    {
      id: "KFdKDYCv5CrdEkMPlPPY",
      title: "Riso Alla Cantonese",
      description: "Riso saltato con uova, prosciutto cotto e piselli.",
      price: new Decimal("3.60"),
    },
    {
      id: "eOuccbWyv3hXdaQTCUxm",
      title: "Riso Con Verdure Miste",
      description: "Riso saltato con uova, carote, zucchine e piselli.",
      price: new Decimal("3.60"),
    },
    {
      id: "tGVLMvzKY8FpgirYVK6P",
      title: "Riso Con Gamberetti",
      description: "Riso saltato con uova, piselli e gamberetti.",
      price: new Decimal("4.40"),
    },
  ];

  await Promise.all(
    firstCourses.map((e) => {
      return productsRef.doc(e.id).set(Serializers.serializeProductDto(e));
    })
  );
});
