/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import { logger } from "firebase-functions";
import * as userRepo from "./users_repository";
import * as jsend from "../jsend";

export async function registerUser(
    uid: string,
    user: any,
    res: functions.Response
) {
    try {
        const email = user["email"] as string;
        const firstName = user["name"] as string;
        const surname = user["lastName"] as string;
        const jobTitle = user["jobTitle"] as string;
        const bio = user["bio"] as string;

        const skills: UserSkills = {
            primarySkills: [],
            secondarySkills: []
        }

        const item: User = {
            email: email,
            name: firstName,
            lastName: surname,
            jobTitle: jobTitle,
            bio: bio,
            skills: skills
        }

        userRepo.insertUser(uid, item);
        res.statusCode = 201;
        res.send(jsend.successWithData({ "message": "User registered" }));
    } catch (e) {
        logger.log(e);
        if (e instanceof userRepo.UserExistsError) {
            res.statusCode = 409;
            res.send(jsend.error("User already registered"));
        } else {
            res.statusCode = 500;
            res.send(jsend.error());
        }
    }
}

// Updates user in firestore and returns a response
export async function updateUser(
    user: any,
    res: functions.Response) {
    try {
        userRepo.editUser(user);
        res.statusCode = 200;
        res.send(jsend.success("User updated successfully"));
    } catch (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}