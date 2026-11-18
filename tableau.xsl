<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>
<xsl:param name="seuil" select="10"/>
<xsl:key name="par-classe" match="etudiant" use="@classe"/>

<xsl:template match="/">
<html>
<head><meta charset="UTF-8"/><title>Promotion Licence 1</title>
<link rel="stylesheet" href="style.css"/></head>
<body>
<header><h1>Promotion Licence 1</h1><p>Année <xsl:value-of select="promotion/@annee"/></p></header>
<main>

<!-- ETAPE 7 : chiffres cles -->
<div class="stats">
  <div class="carte"><div class="valeur"><xsl:value-of select="count(//etudiant)"/></div><div class="legende">Nombre d'étudiants</div></div>
  <div class="carte"><div class="valeur"><xsl:value-of select="count(//etudiant[sum(notes/note) div count(notes/note) &gt;= $seuil])"/></div><div class="legende">Nombre d'admis</div></div>
  <div class="carte"><div class="valeur"><xsl:value-of select="format-number(sum(//note) div count(//note), '0.00')"/></div><div class="legende">Moyenne en XML</div></div>
  <div class="carte"><div class="valeur"><xsl:value-of select="count(//etudiant[not(email)])"/></div><div class="legende">Emails manquants</div></div>
</div>

<!-- ETAPE 8 : un tableau par classe -->
<xsl:for-each select="//etudiant[generate-id() = generate-id(key('par-classe', @classe)[1])]">
  <h2>Classe <xsl:value-of select="@classe"/> (<xsl:value-of select="count(key('par-classe', @classe))"/> étudiants)</h2>
  <table>
    <tr><th>Rang</th><th>Matricule</th><th>Nom</th><th>Classe</th><th>Email</th><th>Moyenne</th><th>Résultat</th></tr>
    <xsl:for-each select="key('par-classe', @classe)">
      <xsl:sort select="sum(notes/note) div count(notes/note)" data-type="number" order="descending"/>
      <!-- ETAPE 9 : major = 1er de chaque classe -->
      <xsl:variable name="moy" select="sum(notes/note) div count(notes/note)"/>
      <tr>
        <xsl:if test="position() = 1"><xsl:attribute name="class">major</xsl:attribute></xsl:if>
        <td class="rang"><xsl:value-of select="position()"/></td>
        <td><xsl:value-of select="@matricule"/></td>
        <td><xsl:value-of select="prenom"/> <xsl:value-of select="nom"/></td>
        <td><xsl:value-of select="@classe"/></td>
        <td><xsl:choose><xsl:when test="email"><xsl:value-of select="email"/></xsl:when><xsl:otherwise><span class="absent">non renseigné</span></xsl:otherwise></xsl:choose></td>
        <td class="moyenne"><xsl:value-of select="format-number($moy, '0.00')"/></td>
        <td><xsl:choose>
          <xsl:when test="$moy &gt;= $seuil"><span class="badge reussite">Admis</span></xsl:when>
          <xsl:otherwise><span class="badge echec">À revoir</span></xsl:otherwise>
        </xsl:choose></td>
      </tr>
    </xsl:for-each>
  </table>
</xsl:for-each>

</main>
<footer><p>Page générée par XSLT</p></footer>
</body>
</html>
</xsl:template>
</xsl:stylesheet>