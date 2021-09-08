/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions";
import * as admin from 'firebase-admin';
import * as userRepo from "./users_repository";

// Used for testing
// Executes POST request to our BE to signup a user.
// Takes a user properties array as argument
export async function postUser(
    url: string,
    properties: any,
    res: functions.Response) {
    await axios.default.post(url,
        { properties: properties })
        .then(function (response) {
            res.statusCode = 200;
            res.send(response.data);
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send(JSON.stringify("Error"));
        });
}

// Used for testing
// Executes PUT request to update a user.
// Takes as parameter the userId and as body the property to update eg.
// { jobTitle: "Senior Manager" }
export async function putUser(
    url: string,
    uid: string,
    property: any,
    res: functions.Response) {
    const fullUrl = url + "?uid=" + uid;
    await axios.default.put(fullUrl,
        { property: property })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(resp.data);
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send(JSON.stringify("Error"));
        });
}

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
            uid: record.uid,
            email: email,
            firstName: firstName,
            surname: surname,
            jobTitle: jobTitle,
            bio: bio,
            confluenceConnected: false,
            skills: skills
        }
        // Add user in firestore
        userRepo.insertUser(user);
        res.statusCode = 200;
        res.send(JSON.stringify("User created"));
    }).catch(function (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(JSON.stringify("Error creating user"));
    });
}

// Updates user in firestore and returns a response
export function updateUser(
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