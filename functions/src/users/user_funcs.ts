/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import { logger } from "firebase-functions";
import * as userRepo from "./users_repository";
import * as jsend from "../jsend";

// Adds a user in firestore and returns a response with a message
export async function registerUser(
    uid: string,
    user: any,
    res: functions.Response
) {
    try {
        const email = user["email"] as string;
        const name = user["name"] as string;
        const lastName = user["lastName"] as string;
        const jobTitle = user["jobTitle"] as string;
        const bio = user["bio"] as string;

        const skills: UserSkills = {
            primarySkills: [],
            secondarySkills: []
        }

        const item: User = {
            email: email,
            name: name,
            lastName: lastName,
            jobTitle: jobTitle,
            bio: bio,
            skills: skills
        }

        userRepo.insertUser(uid, item);
        res.status(201).send(jsend.successfullResponse({ "message": "User registered" }));
    } catch (e) {
        logger.log(e);
        if (e instanceof userRepo.UserExistsError) {
            res.status(409).send(jsend.error("User already registered"));
        } else {
            res.status(500).send(jsend.error());
        }
    }
}

// Updates user in firestore and returns a response with the updated user
export async function updateUser(
    uid: string,
    user: any,
    res: functions.Response) {
    try {
        const item = await userRepo.editUser(uid, user);
        res.status(200).send(jsend.successfullResponse(item));
    } catch (e) {
        logger.log(e);
        res.status(500).send(jsend.error());
    }
}

// Returns a response with firestore user of given id
export async function getUser(
    id: string,
    res: functions.Response) {
    try {
        const user = await userRepo.getUser(id);
        res.status(200).send(jsend.successfullResponse(user));
    } catch (e) {
        logger.log(e);
        res.status(500).send(jsend.error());
    }
}