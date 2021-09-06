import { firestore } from "firebase-admin"
import { logger } from "firebase-functions/v1";

const SKILLS_COLLECTION = "skills"

export async function getSkillsForUser(userId: string): Promise<Skills[]> {
    const dbCollection = firestore().collection(SKILLS_COLLECTION);

    try {
        const querySnapshot = await dbCollection
            .where("userId", "==", userId)
            .get();

        const items = Array<Skills>();
        querySnapshot.forEach((doc) => {
            const item = doc.data();
            console.log(item);
            items.push(item as Skills);
        });

        return items;
    }
    catch (error) {
        throw "Is not possible to get the data";
    }
}

export async function upsert(item: Skills) {
    const dbCollection = firestore().collection(SKILLS_COLLECTION);
    const querySnapshot = await dbCollection
        .where("userId", "==", item.userId)
        .get();
    if (querySnapshot.empty) {
        await insert(item);
    }
    else {
        await update(item);
    }
}

async function update(item: Skills) {
    const dbCollection = firestore().collection(SKILLS_COLLECTION);
    try {
        logger.log("Updating skills document");
        await dbCollection.doc().update(item);
    }
    catch (error) {
        logger.log("Is not possible to update the item");
        throw error;
    }
}

async function insert(item: Skills) {
    const dbCollection = firestore().collection(SKILLS_COLLECTION);
    try {
        logger.log("Inserting new skills document");
        await dbCollection.doc().create(item);
    }
    catch (error) {
        logger.log("Is not possible to insert the item");
        throw error;
    }
}