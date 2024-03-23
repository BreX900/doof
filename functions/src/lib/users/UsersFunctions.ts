import * as functions from "firebase-functions";
import { firestore } from "../instances";

export const onCreateUser = functions.auth
  .user()
  .onCreate(async (user, context) => {
    const userDto: UserDto = {
      id: user.uid,
      email: user.email!,
      displayName: user.displayName,
    };

    await firestore.doc(user.uid).set(userDto);
  });
