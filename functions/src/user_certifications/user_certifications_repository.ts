/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';

const TABLE_CERTIFICATIONS = "User Certifications";

export class UserCertificationFirestoreError extends Error { }
export class UserCertificationExistsError extends UserCertificationFirestoreError { }
export class UserCertificationNotFoundError extends UserCertificationFirestoreError { }

export async function insert(
    uid: string,
    item: any,
) {
    const db = admin.firestore();
    const collection = db.collection(TABLE_CERTIFICATIONS);
    const snap = await collection
        .where("userId", "==", uid)
        .where("certificationId", "==", item["certificationId"]).get();

    if (snap.empty) {

        const userId = item["userId"];
        const certificationId = item["certificationId"];
        const isCompleted = item["isCompleted"];
        const startDate = item["startDate"];
        const completionDate = item["completionDate"];
        const expiryDate = item["expiryDate"];
        const rating = item["rating"];

        const docRef = await collection.add({
            userId: userId,
            certificationId: certificationId,
            isCompleted: isCompleted,
            startDate: startDate,
            completionDate: completionDate,
            expiryDate: expiryDate,
            rating: rating
        });

        return {
            id: docRef.id,
            userId: userId,
            certificationId: certificationId,
            isCompleted: isCompleted,
            startDate: startDate,
            completionDate: completionDate,
            expiryDate: expiryDate,
            rating: rating
        }
    }
    else throw new UserCertificationExistsError();
}

export async function update(
    id: string,
    certification: any
) {
    const doc = admin.firestore().collection(TABLE_CERTIFICATIONS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        doc.update(certification);
    } else {
        throw new UserCertificationNotFoundError();
    }
}

// "delete" is a reserved word
export async function deleteItem(
    id: string
) {
    const doc = admin.firestore().collection(TABLE_CERTIFICATIONS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        doc.delete();
    } else {
        throw new UserCertificationNotFoundError();
    }
}

export async function getAllUsers(): Promise<any[]> {
    const snapshot = await admin.firestore()
        .collection(TABLE_USERS).get();
    return toUsers(snapshot);
}

async function toUserCertifications(snapshot: FirebaseFirestore.QuerySnapshot):
    Promise<any[]> {
    const users = Array<any>();
    if (!snapshot.empty) {
        snapshot.forEach((doc: { data: () => any }) => {
            var item = doc.data() as User
            users.push({
                name: item.name,
                lastName: item.lastName,
                email: item.email,
                jobTitle: item.jobTitle,
                bio: item.bio,
                skills: item.skills
            });
        });
    }
    return users;
}
