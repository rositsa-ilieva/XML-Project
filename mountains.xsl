<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Каталог на планините</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
                <style>
                    <![CDATA[
                    body {
                        background-color: #f4f4f9;
                        font-family: Arial, sans-serif;
                    }

                    .mountain-card {
                        background-color: #2b3847;
                        color: white;
                        margin: 10px;
                        border-radius: 5px;
                        padding: 10px;
                        text-align: center;
                        box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
                        width: 350px;
                        height: 400px;
                    }

                    .mountain-card img {
                        border-radius: 5px;
                        width: 100%;
                        height: 150px;
                        object-fit: cover;
                    }
                    ]]>
                </style>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const imageMapping = {
                            "rila": "https://i.postimg.cc/MGCgBMmX/rila.jpg",
                            "pirin": "https://i.postimg.cc/cCZjDpjS/pirin.jpg",
                            "rodopi": "https://i.postimg.cc/4dpqQfWP/rodopi.jpg",
                            "stara-planina": "https://i.postimg.cc/MHDLgs2j/stara-planina.jpg",
                            "osogovska": "https://i.postimg.cc/c1MPKJg4/osogovska.jpg",
                            "belasitsa": "https://i.postimg.cc/s2Qt19St/belasitsa.jpg",
                            "vitosha": "https://i.postimg.cc/8CMtqyLP/vitosha.jpg",
                            "slavyanka": "https://i.postimg.cc/pTBkdp0w/slavyanka.jpg"
                        };

                        document.querySelectorAll(".mountain-card img").forEach(img => {
                            const entity = img.getAttribute("data-source");
                            if (imageMapping[entity]) {
                                img.src = imageMapping[entity];
                            }
                        });
                    });

                    function toggleSort(attribute, order) {
                        const container = document.querySelector('#content .row');
                        const cards = Array.from(container.querySelectorAll('.mountain-card'));

                        cards.sort((a, b) => {
                            const aValue = a.getAttribute(`data-${attribute}`);
                            const bValue = b.getAttribute(`data-${attribute}`);

                            if (attribute === 'height') {
                                return order === 'asc'
                                    ? Number(aValue) - Number(bValue)
                                    : Number(bValue) - Number(aValue);
                            } else {
                                return order === 'asc'
                                    ? aValue.localeCompare(bValue)
                                    : bValue.localeCompare(aValue);
                            }
                        });

                        container.innerHTML = '';
                        cards.forEach(card => container.appendChild(card));
                    }

                    function resetSort() {
                        const container = document.querySelector('#content .row');
                        const cards = Array.from(container.querySelectorAll('.mountain-card'));

                        cards.sort((a, b) => {
                            const aIndex = a.getAttribute('data-index');
                            const bIndex = b.getAttribute('data-index');
                            return Number(aIndex) - Number(bIndex);
                        });

                        container.innerHTML = '';
                        cards.forEach(card => container.appendChild(card));
                    }
                </script>
            </head>
            <body>
                <h1 class="text-center my-4">Каталог на планините</h1>
                <div class="text-center mb-4">
                    <div class="dropdown">
                        <button class="btn dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                            Сортирай по
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <li><a class="dropdown-item" href="#" onclick="toggleSort('height', 'asc')">Височина ↑</a></li>
                            <li><a class="dropdown-item" href="#" onclick="toggleSort('height', 'desc')">Височина ↓</a></li>
                            <li><a class="dropdown-item" href="#" onclick="toggleSort('type', 'asc')">Вид А-Я</a></li>
                            <li><a class="dropdown-item" href="#" onclick="toggleSort('type', 'desc')">Вид Я-А</a></li>
                            <li><a class="dropdown-item" href="#" onclick="toggleSort('region', 'asc')">Регион А-Я</a></li>
                            <li><a class="dropdown-item" href="#" onclick="toggleSort('region', 'desc')">Регион Я-А</a></li>
                            <li><a class="dropdown-item" href="#" onclick="resetSort()">Рестартиране</a></li>
                        </ul>
                    </div>
                </div>
                <div id="content" class="container-fluid mt-4">
                    <div class="row row-cols-auto">
                        <xsl:apply-templates select="catalogue/mountains/mountain"/>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="mountain">
        <div class="col mountain-card"
             data-index="{position()}"
             data-height="{height}"
             data-type="{@type}"
             data-region="{/catalogue/regions/region[@id=current()/@region]/area}">
            <img src="https://i.postimg.cc/{thumbnail/@source}.jpg" alt="{name}" />
            <h3><xsl:value-of select="name"/></h3>
            <p><strong>Височина:</strong> <xsl:value-of select="height"/> м</p>
            <p><strong>Най-висок връх:</strong> <xsl:value-of select="peak"/></p>
            <p><strong>Вид:</strong> <xsl:value-of select="@type"/></p>
            <p><strong>Регион:</strong> <xsl:value-of select="/catalogue/regions/region[@id=current()/@region]/area"/></p>
        </div>
    </xsl:template>
</xsl:stylesheet>
