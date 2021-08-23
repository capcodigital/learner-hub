import data from './catalog.json';

export type CatalogEntry = {
    id: number;
    name: string;
    category: string;
    subcategory: string;
    url: string;
    contentUrl: string;
};

export const getUrl = (id: number): string => {
    const certFilter: CatalogEntry[] = data.filter((c: CatalogEntry) => c.id == id);
    console.log(certFilter);
    var url = (certFilter.length > 0) ? (certFilter[0].url) : ("");
    return url;
}

export const getById = (id: number): CatalogEntry => {
    const certFilter: CatalogEntry[] = data.filter((c: CatalogEntry) => c.id == id);
    return certFilter[0];
}