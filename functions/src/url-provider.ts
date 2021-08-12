import catalog from './catalog.json';
import { logger } from "firebase-functions/lib";
import { Request, Response } from "express";


const catalogUrls = (<CatalogUrl[]>catalog);
// read from Json , later we will read from Firebase storage

type CatalogUrl = {
    id: number;
    name: String;
    category: String;
    subcategory: String;
    url:String;
};

function getCatalogUrl (catalogUrl: CatalogUrl) {
    return catalogUrl.url;
};

export const  getUrl = (request: Request, response: Response) : String => {

}