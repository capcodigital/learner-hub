/* eslint-disable require-jsdoc */
import * as admin from 'firebase-admin';
import * as summaryRepo from '../certification_summaries/certification_summary_repository';
import * as userRepo from '../users/users_repository';
import { AssocArray } from '../assoc_array';

const TABLE_TODOS = "TODOs";

export class TODOFirestoreError extends Error { }
export class TODOExistsError extends TODOFirestoreError { }
export class TODONotFoundError extends TODOFirestoreError { }
export class AccessForbidenError extends TODOFirestoreError { }

export async function getUserTODOs(uid: string): Promise<any[]> {
    const collection = admin.firestore().collection(TABLE_TODOS);
    // Calling getUser will throw UserNotFoundError if user not found
    userRepo.getUser(uid);
    const snap = await collection.where("userId", "==", uid).get();
    return toCertifications(snap);
}

export async function insert(
    uid: string,
    item: any,
) {
    const col = admin.firestore().collection(TABLE_TODOS);
    const certificationId = item["certificationId"];
    const snap = await col.where("userId", "==", uid)
        .where("certificationId", "==", certificationId).get();

    if (snap.empty) {

        const isCompleted = item["isCompleted"];
        const startDate = item["startDate"];
        const completionDate = item["completionDate"];
        const expiryDate = item["expiryDate"];
        const rating = item["rating"];

        const docRef = await col.add({
            userId: uid,
            certificationId: certificationId,
            isCompleted: isCompleted,
            startDate: startDate,
            completionDate: completionDate,
            expiryDate: expiryDate,
            rating: rating
        });

        return {
            id: docRef.id, // adding doc id in result
            userId: uid,
            certificationId: certificationId,
            isCompleted: isCompleted,
            startDate: startDate,
            completionDate: completionDate,
            expiryDate: expiryDate,
            rating: rating
        }
    }
    else throw new TODOExistsError();
}

export async function update(
    uid: string,
    id: string,
    certification: any
) {
    const doc = admin.firestore().collection(TABLE_TODOS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        const item = docRef.data() as UserCertification;
        if (uid == item.userId) {
            doc.update(certification);
            const updated = docRef.data() as UserCertification;
            return {
                id: docRef.id, // adding doc id in result
                userId: updated.userId,
                certificationId: updated.certificationId,
                isCompleted: updated.isCompleted,
                startDate: updated.startDate,
                completionDate: updated.completionDate,
                expiryDate: updated.expiryDate,
                rating: updated.rating
            }
        } else throw new AccessForbidenError("Certification is not of current user");
    } else throw new TODONotFoundError();
}

// "delete" is a reserved word
export async function deleteItem(
    uid: string,
    id: string
) {
    const doc = admin.firestore().collection(TABLE_TODOS).doc(id);
    const docRef = await doc.get();
    if (docRef.exists) {
        const item = docRef.data() as UserCertification;
        if (uid == item.userId) doc.delete();
        else throw new AccessForbidenError("Certification is not of current user");
    } else {
        throw new TODONotFoundError();
    }
}

async function toCertifications(snap: FirebaseFirestore.QuerySnapshot):
    Promise<any[]> {
    const summaries: AssocArray = await summaryRepo.getAllCertificationSummaries();
    const items = Array<any>();
    if (!snap.empty) {
        snap.forEach((doc: { data: () => any }) => {
            var it = doc.data() as UserCertification;
            const summary = summaries[it.certificationId];
            items.push({
                userId: it.userId,
                certificationSummary: summary,
                isCompleted: it.isCompleted,
                startDate: it.startDate,
                completionDate: it.completionDate,
                expiryDate: it.expiryDate,
                rating: it.rating
            });
        });
    }
    return items;
}
