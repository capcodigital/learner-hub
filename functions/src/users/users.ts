/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import { logger } from "firebase-functions";
import * as admin from 'firebase-admin';
import * as userRepo from "./users_repository";

// Creates user in firebase auth and adds them to firestore 
// Users collection
export async function registerUser(
    properties: any,
    res: functions.Response
) {
    const email = properties["email"] as string;
    const password = properties["password"] as string;
    const firstName = properties["firstName"] as string;
    const surname = properties["surname"] as string;
    const jobTitle = properties["jobTitle"] as string;
    const bio = properties["bio"] as string;
    // Add user in firebase auth
    admin.auth().createUser({
        email: email,
        emailVerified: false,
        password: password,
        displayName: firstName + " " + surname,
        disabled: false,
    }).then(function (record) {
        logger.log("User created:", record.uid);
        const skills: UserSkills = {
            primarySkills: [],
            secondarySkills: []
        }
        const user: User = {
            email: email,
            firstName: firstName,
            surname: surname,
            jobTitle: jobTitle,
            bio: bio,
            confluenceConnected: false,
            skills: skills
        }
        // Add user in firestore
        userRepo.insertUser(record.uid, user);
        res.statusCode = 200;
        res.send(JSON.stringify("User created"));
    }).catch(function (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(JSON.stringify("Error creating user"));
    });
}

// Updates user in firestore and returns a response
export async function updateUser(
    userId: string,
    property: any,
    res: functions.Response) {
    try {
        userRepo.editUser(userId, property);
        res.statusCode = 200;
        res.send(JSON.stringify("User updated"));
    } catch (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(JSON.stringify("Error updating user"));
    }
}

export async function getUsers(res: functions.Response) {
    try {
        const items = await userRepo.getAllUsers();
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(JSON.stringify(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(JSON.stringify("Error getting users"));
    }
}