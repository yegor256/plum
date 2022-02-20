<?xml version="1.0" encoding="UTF-8"?>
<!--
The MIT License (MIT)

Copyright (c) 2022 Yegor Bugayenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:template match="metrics">
    <xsl:variable name="root" select="."/>
    <table id="languages">
      <thead>
        <tr>
          <th/>
          <th>
            <xsl:text>DOB</xsl:text>
          </th>
          <xsl:for-each-group select="$root/m" group-by="@script">
            <xsl:variable name="script" select="@script"/>
            <th class="sorter">
              <xsl:text>⇅ </xsl:text>
              <xsl:value-of select="/plum/scripts/script[@id=$script]"/>
            </th>
          </xsl:for-each-group>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each-group select="$root/m" group-by="@lang">
          <xsl:variable name="lang" select="/plum/catalog/*[name()=current-grouping-key()]"/>
          <tr>
            <th class="left">
              <a>
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="$lang/home">
                      <xsl:value-of select="$lang/home"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$lang/wikipedia"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="$lang/name"/>
              </a>
            </th>
            <td>
              <xsl:value-of select="$lang/year-of-birth"/>
            </td>
            <xsl:for-each select="current-group()">
              <xsl:variable name="script" select="@script"/>
              <td>
                <xsl:apply-templates select="v"/>
              </td>
            </xsl:for-each>
          </tr>
        </xsl:for-each-group>
      </tbody>
    </table>
  </xsl:template>
  <xsl:template match="v">
    <xsl:if test="@hint">
      <xsl:attribute name="title">
        <xsl:value-of select="@hint"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:value-of select="text()"/>
  </xsl:template>
  <xsl:template match="plum">
    <html>
      <head>
        <title>PLUM</title>
        <meta charset='UTF-8'/>
        <meta content='width=device-width, initial-scale=1.0' name='viewport'/>
        <link rel="icon" href="https://raw.githubusercontent.com/yegor256/plum/logo-64.png" type="image/png"/>
        <link href='https://cdn.jsdelivr.net/gh/yegor256/tacit@gh-pages/tacit-css.min.css' rel='stylesheet'/>
        <link href='https://cdn.jsdelivr.net/gh/yegor256/drops@gh-pages/drops.min.css' rel='stylesheet'/>
        <style>
          td, th { text-align: right; font-family: monospace; font-size: 18px; }
          .left { border-bottom: 0; }
          header { text-align: center; }
          footer { text-align: center; font-size: 0.8em; }
          .sorter { cursor: pointer; }
        </style>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"/>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.3/js/jquery.tablesorter.min.js"/>
        <script type="text/javascript">
          $(function() {
            $("#languages").tablesorter();
          });
        </script>
      </head>
      <body>
        <header>
          <p>
            <xsl:text>This is a curated list of programming languages with some metrics:</xsl:text>
          </p>
        </header>
        <xsl:apply-templates select="metrics" />
        <footer>
          <p>
            <xsl:text>If you want to add another language to the list, just submit a pull request to </xsl:text>
            <a href="https://github.com/yegor256/plum">
              <xsl:text>yegor256/plum</xsl:text>
            </a>
            <xsl:text>.</xsl:text>
            <br/>
            <xsl:text>Here is </xsl:text>
            <a href="index.xml">
              <xsl:text>index.xml</xsl:text>
            </a>
            <xsl:text> with the data.</xsl:text>
          </p>
          <p>
            <xsl:text>Built on </xsl:text>
            <xsl:value-of select="@date"/>
            <xsl:text> by </xsl:text>
            <a href="https://www.yegor256.com">
              <xsl:text>@yegor256</xsl:text>
            </a>
          </p>
        </footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
