import axios from "axios";
import { firestore } from "firebase-admin";
import { logger } from "firebase-functions/v1";
import { CatalogEntry, getById } from "./catalog_entry";
import { extractSecurityCertifications } from "./htmlHelpers/api_security";
import { extractCloudCertifications } from "./htmlHelpers/cloud_training";
import { extractNeo4jCertifications } from "./htmlHelpers/neo4j";

const TABLE_CERTIFICATIONS = "certifications"

export async function syncAllCertifications(): Promise<Certification[]> {
    // Define the items to sync and the HTML parser used to extract the certifications from the HTML
    var dataSources = [
        { id: 2, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractCloudCertifications(html, certData) },
        { id: 3, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractCloudCertifications(html, certData) },
        { id: 7, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractNeo4jCertifications(html, certData) },
        { id: 8, htmlParser: (html: string, certData: CatalogEntry): Array<Certification> => extractSecurityCertifications(html, certData) }
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
    logger.log(`Processed ${certifications.length} certifications types`);

    // Flatten array of arrays. Since flatMap is not supported, just reduce as alternative
    const allCertifications = certifications.reduce((acc, x) => acc.concat(x), []);

    // Save all certifications in the DB
    await save(allCertifications);

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

// TODO: Extract this save logic to a repository
// Saves a list of certifications in a Firestore collection
async function save(items: Array<Certification>) {
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        await firestore().collection(TABLE_CERTIFICATIONS).add({
            name: filter(item.name),
            platform: filter(item.platform.toLowerCase()),
            certification: filter(item.certification),
            category: filter(item.category).toLowerCase(),
            subcategory: filter(item.subcategory).toLowerCase(),
            date: filter(item.date),
            description: filter(item.description),
            rating: filter(item.rating),
        });
    }
}

function filter(text: string): string {
    return text != null ? text : "";
}