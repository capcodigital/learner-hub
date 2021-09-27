/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as jsend from "../jsend";
import * as userCertRepo from "./user_certifications_repository";

export async function addUserCertification(
    uid: string,
    userCert: any,
    res: functions.Response) {
    try {
        const item = await userCertRepo.insert(uid, userCert);
        functions.logger.log(item);
        res.setHeader('Content-Type', 'application/json');
        res.status(201).send(jsend.successfullResponse(item));
    } catch (e) {
        functions.logger.log(e);
        res.status(500).send(jsend.error);
    }
}

export async function updateUserCertification(
    id: string,
    cert: string,
    res: functions.Response) {
    try {
        const item = userCertRepo.update(id, cert);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse(item));
    } catch (e) {
        functions.logger.log(e);
        res.status(500).send(jsend.error);
    }
}

export async function getUserCertifications(
    uid: string,
    res: functions.Response) {
    try {
        const items = await userCertRepo.getUserCertifications(uid);
        functions.logger.log(items);
        res.setHeader('Content-Type', 'application/json');
        // TODO: Format response as per the API docs i.e. each json
        // item contains the full certificationSummary, not just
        // the certification id
        res.status(200).send(jsend.successfullResponse(items));
    } catch (e) {
        functions.logger.log(e);
        if (e instanceof userCertRepo.UserNotFoundError)
            res.status(404).send(jsend.error("User not found"));
        else res.status(500).send(jsend.error);
    }
}

export async function deleteUserCertification(
    id: string,
    res: functions.Response) {
    try {
        userCertRepo.deleteItem(id);
        res.setHeader('Content-Type', 'application/json');
        res.status(200).send(jsend.successfullResponse({ "message": "Item deleted" }));
    } catch (e) {
        functions.logger.log(e);
        res.status(500).send(jsend.error);
    }
}

