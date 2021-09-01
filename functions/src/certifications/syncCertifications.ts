import axios from "axios";
import { logger } from "firebase-functions/v1";
import { save } from "../firestore_funs";
import { CatalogEntry, getById } from "./catalog_entry";
import { extractSecurityCertifications } from "./htmlHelpers/api_security";
import { extractCloudCertifications } from "./htmlHelpers/cloud_training";
import { extractCordaCertifications } from "./htmlHelpers/corda";
import { extractNeo4jCertifications } from "./htmlHelpers/neo4j";
import { extractUdemySecurityCourses } from "./htmlHelpers/udemy-security-courses";
import { extractVaultCertifications } from "./htmlHelpers/vault";

export async function syncAllCertifications(): Promise<Certification[]> {
    // Define the items to sync and the HTML parser used to extract the certifications from the HTML
    var dataSources = [
        { id: 1, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractUdemySecurityCourses(html, certData) },
        { id: 2, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractCloudCertifications(html, certData) },
        { id: 3, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractCloudCertifications(html, certData) },
        { id: 4, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractCordaCertifications(html, certData) },
        { id: 7, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractNeo4jCertifications(html, certData) },
        { id: 8, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractSecurityCertifications(html, certData) },
        { id: 9, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractVaultCertifications(html, certData) }
    ];

    // Create the promises to run in parallel all the data
    const promises = dataSources.map(async source => {
        const id = source.id;
        const htmlParser = source.htmlParser;
        const catalogItem = getById(id);

        logger.log(`Parsing data for Catalog Item ${catalogItem.id} - ${catalogItem.name}`);

        const html = await getHtmlContent(catalogItem.contentUrl)
        const items = htmlParser(html, catalogItem);
        return items;
    });

    // Wait for all the data to be downloaded
    const certifications = await Promise.all(promises);

    // Flatten array of arrays. Since flatMap is not supported, just reduce as alternative
    const allCertifications = certifications.reduce((acc, x) => acc.concat(x), []);

    // Save all certifications in the DB
    await save(allCertifications);

    logger.log(`Processed a total of ${allCertifications.length} certifications in ${certifications.length} certifications types`);

    return allCertifications;
}

async function getHtmlContent(url: string): Promise<string> {
    try {
        var response = await axios.get<ConfluenceResponse>(url, {
            auth: {
                username: "email",
                password: "token"
            }
        });

        return response.data.body.export_view.value;
    }
    catch (error) {
        logger.log(error);
        throw error;
    }
}