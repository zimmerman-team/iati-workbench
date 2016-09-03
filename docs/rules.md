---
layout: default
title: Rules
---

# Rules for data quality

Checking the data for quality is done with rules: the original XML data is
inspected, and extra XML is inserted to flag possible issues with the data.

Rules are expressed as tests in XSLT templates. The template matches the context
in which the test has to be performed, and if the test is positive, a special
feedback element is inserted, using the `iati-me` namespace.

This makes it possible to later create a report on those feedback elements,
with the complete data context available.

## The anatomy of rules

Rules can be stored in multiple stylesheets for easier maintenance. This poses a
challenge in properly applying them all: normally, only a single match for an
XSLT template will be applied.

Therefore, each template will have a `priority` attribute (a numerical value)
and end with the statement `<xsl:next-match/>` so that any other matching
templates with lower priorities will also be applied.

The actual order in which the tests are run is not important to us, so we use
a different "base integer" in each stylesheet, and simply add decimals for the
order within the file.

### First example

An example of such a template with rules:

``` xml
<xsl:template match="iati-activity" mode="rules" priority="3.1">

  <xsl:if test="count(recipient-country|recipient-region) > 1">
    <xsl:if test="sum((recipient-country|recipient-region)/@percentage) != 100">
      <iati-me:feedback type="danger" class="geo">
        Percentages for recipient-country and recipient-region don't add up
        to 100%.
      </iati-me:feedback>
    </xsl:if>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>
```

The test is applied to each single activity (`match="iati-activity"`), when we
are checking for rules (`mode="rules"`). As said, the actual `priority="3.1"`
only needs to be unique, and is not really important in any other way.

In this case, we do a two-step test: first, we test if there are multiple
`recipient-country` or `recipient-region` elements, and if so, next we sum all
the `@percentage` attributes and verify they add up to 100.

If not, the test is positive, and an `iati-me:feedback` element is added.

The element has an attribute `type` to indicate the severity. This uses the four
levels in bootstrap: danger, warning, info and success. So it is possible
to also test for good practices, and offer positive feedback of type success.

The feedback also has a class, in this case `geo`, to allow grouping of
feedback.

Next is the actual message that can be presented in a report.

### More complex tests

It is also possible to add more complex tests, since it is all just XSLT.

In the next example, we again look at a single activity (notice: with a
different priority), and do a series of tests.

The first is a complex test: we look at all sector codes, grouped by vocabulary.
Within each category, we first test if there are multiple sector codes.

If so, we have two tests:

1. First, we check if any of the sectors in this vocabulary misses the required
percentage attribute: `test="count(current-group()[not(@percentage)]) > 0"`.
2. And next, we check if the sum of all percentages differs from 100%:
`test="sum(current-group()/@percentage) != 100"`.

After we have done this, we also check if a `sector` element occurs on both
the activity and the transaction level. In this feedback element, we have added
a reference to a page with more information: the `href` attribute.


```xml
<xsl:template match="iati-activity" mode="rules" priority="2.1">

  <!-- Check for multiple sector codes per vocabulary. -->
  <xsl:for-each-group select="sector" group-by="@vocabulary">
    <xsl:if test="count(current-group()) > 1">

      <xsl:if test="count(current-group()[not(@percentage)]) > 0">
        <iati-me:feedback type="danger" class="sectors">
          One or more sectors in vocabulary <code><xsl:value-of select="current-grouping-key()"/></code>
          have no percentage: <xsl:value-of select="string-join(current-group()[not(@percentage)]/@code, ', ')"/>
        </iati-me:feedback>
      </xsl:if>

      <xsl:if test="sum(current-group()/@percentage) != 100">
        <iati-me:feedback type="danger" class="sectors">
          Percentages for sectors in vocabulary <code><xsl:value-of select="current-grouping-key()"/></code>
          don't add up to 100%.
        </iati-me:feedback>
      </xsl:if>

    </xsl:if>
  </xsl:for-each-group>

  <xsl:if test="count(sector)>0 and count(transaction/sector)>0">
    <iati-me:feedback type="info" class="sectors"
      href="http://iatistandard.org/202/activity-standard/iati-activities/iati-activity/sector/#definition">
      You are using sectors in both the activity and transactions in the
      activity. You should only use them in one place.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>
```

### Adding a source for the rules

It is possible to add a (single) source for a rule, for instance to indicate
a donor or internal guideline.

*This part will likely change in a future version, to make it easier to have
multiple sources for a rule.*

```xml
<xsl:template match="iati-activities" mode="rules" priority="100.1">

  <xsl:if test="not(//transaction[transaction-type/@code='11' and provider-org/@ref='XM-DAC-7' and provider-org/@provider-activity-id])">

    <iati-me:feedback type="warning" class="traceability" src="minbuza">
      Include at least one activity with a transaction
      of type <code>11</code> (incoming commitment) that refers to the
      Ministry (<code>XM-DAC-7</code>) as the provider, and that refers to
      a specific activity identifier of the Ministry.
    </iati-me:feedback>
  </xsl:if>

  <xsl:next-match/>
</xsl:template>
```

In this example, we look at a dataset as a whole, and look for a transaction
of type `11` where the provider is the Dutch MFA and there is an activity
identifier specified.
