/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import { logger } from "firebase-functions";
import * as jsend from "../jsend";
import * as summaryRepo from "./certification_summary_repository";

export async function getAllCertificationSummaries(res: functions.Response) {
    try {
        const items = await summaryRepo.getAllCertificationSummaries();
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successGetSummaries(items));
    } catch (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

export async function getCertificationSummary(
    id: string,
    res: functions.Response) {
    try {
        const summary = await summaryRepo.getCertificationSummary(id);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successGetSummaries([summary]));
    } catch (e) {
        logger.log(e);
        res.statusCode = 404;
        res.send(jsend.error("Certification does not exist"));
    }
}

export async function addCertificationSummary(
    summary: any,
    res: functions.Response) {
    try {
        const item = await summaryRepo.saveSummary(summary as CertificationSummary);
        logger.log(item);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 201;
        res.send(jsend.successAddSummary(item));
    } catch (e) {
        logger.log(e);
        res.statusCode = 500;
        res.send(jsend.error());
    }
}



