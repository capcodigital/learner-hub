import { logger } from "firebase-functions/v1";
import { getSkillsForUser, upsert } from "./skills-repository";

export async function getUserSkills(userId: string): Promise<Skills[]> {
    logger.log('Getting all the user skills');

    try {
        const items = await getSkillsForUser(userId);
        return items;
    }
    catch (error) {
        logger.log(`It's not possible to get the user skills: ${error}`);
        throw "Is not possible to get the data";
    }
}

export async function saveSkills(userId: string, primary: string[], secondary: string[]) {
    logger.log('Saving skills for the user');

    try {
        await upsert({
            userId: userId,
            primarySkills: primary,
            secondarySkills: secondary
        });
    }
    catch (error) {
        logger.log(`It's not possible to get the user skills: ${error}`);
        throw "Is not possible to get the data";
    }
}