/* eslint-disable require-jsdoc */
import * as admin from "firebase-admin";

const TABLE_USERS = "users";

export class UserFirestoreError extends Error {}
export class UserExistsError extends UserFirestoreError {}
export class UserNotFoundError extends UserFirestoreError {}

export async function insertUser(uid: string, user: User) {
  console.log(`USER PAYLOAD: ${JSON.stringify(user, null, 4)}`);
  const doc = admin.firestore().collection(TABLE_USERS).doc(uid);
  const docRef = await doc.get();
  if (!docRef.exists) {
    doc.create({
      name: user.name,
      lastName: user.lastName,
      email: user.email,
      jobTitle: user.jobTitle,
      bio: user.bio,
      skills: user.skills,
    });
  } else throw new UserExistsError();
}

export async function editUser(uid: string, user: any) {
  const col = admin.firestore().collection(TABLE_USERS);
  const doc = col.doc(uid);
  const docRef = await doc.get();
  if (docRef.exists) {
    doc.update(user);
  } else throw new UserNotFoundError();
}

export async function getUser(id: any) {
  const col = admin.firestore().collection(TABLE_USERS);
  const doc = col.doc(id);
  const docRef = await doc.get();
  if (docRef.exists) return docRef.data();
  else throw new UserNotFoundError();
}
