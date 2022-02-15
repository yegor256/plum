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
  <xsl:template match="m">
    <xsl:value-of select="v"/>
  </xsl:template>
  <xsl:template match="metrics">
    <xsl:variable name="root" select="."/>
    <html>
      <head>
        <title>PLUM</title>
        <meta charset='UTF-8'/>
        <meta content='width=device-width, initial-scale=1.0' name='viewport'/>
        <link href='https://cdn.jsdelivr.net/gh/yegor256/tacit@gh-pages/tacit-css.min.css' rel='stylesheet'/>
        <link href='https://cdn.jsdelivr.net/gh/yegor256/drops@gh-pages/drops.min.css' rel='stylesheet'/>
        <style>
          td, th { text-align: right; }
          .left { border-bottom: 0; }
        </style>
      </head>
      <body>
        <table>
          <thead>
            <tr>
              <th/>
              <xsl:for-each-group select="$root/m" group-by="@script">
                <th>
                  <xsl:value-of select="@script"/>
                </th>
              </xsl:for-each-group>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each-group select="$root/m" group-by="@lang">
              <xsl:variable name="lang" select="current-group()[1]/@lang"/>
              <tr>
                <th class="left">
                  <xsl:value-of select="$lang"/>
                </th>
                <xsl:for-each select="current-group()">
                  <xsl:variable name="script" select="@script"/>
                  <td>
                    <xsl:value-of select="v"/>
                  </td>
                </xsl:for-each>
              </tr>
            </xsl:for-each-group>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
