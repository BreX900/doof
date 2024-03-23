import * as admin from "firebase-admin";

const app = admin.initializeApp();

export const firestore = admin.firestore(app);
