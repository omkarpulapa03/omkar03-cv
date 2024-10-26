#import "template/cv.typ": *

#let cvdata = yaml("resume.yml")

#let uservars = (
    headingfont: "Linux Libertine",
    bodyfont: "Linux Libertine",
    fontsize: 11pt, // 10pt, 11pt, 12pt
    linespacing: 6pt,
    showAddress: true, // true/false show address in contact info
    showNumber: true,  // true/false show phone number in contact info
    headingsmallcaps: false
)

// setrules and showrules can be overridden by re-declaring it here
// #let setrules(doc) = {
//      // add custom document style rules here
//
//      doc
// }

#let customrules(doc) = {
    // add custom document style rules here
    set page(
        paper: "us-letter", // a4, us-letter
        numbering: "1 / 1",
        number-align: center, // left, center, right
        margin: 1.25cm, // 1.25cm, 1.87cm, 2.5cm
    )

    doc
}

#let cvinit(doc) = {
    doc = setrules(uservars, doc)
    doc = showrules(uservars, doc)
    doc = customrules(doc)

    doc
}

// each section body can be overridden by re-declaring it here

#let cvabout(info, isbreakable: true) = {
    if info.about != none {block(breakable: isbreakable)[
        == Introduction
        #info.about
    ]}
}

#let cvcertificates(info, isbreakable: true) = {
    if info.certificates != none {block[
        == Certifications

        #for cert in info.certificates {
            // parse ISO date strings into datetime objects
            let date = utils.strpdate(cert.date)
            // create a block layout for each certificate entry
            block(width: 100%, breakable: isbreakable)[
                // line 1: certificate name
                #if cert.url != none [
                    *#link(cert.url)[#cert.name]* \
                ] else [
                    *#cert.name* \
                ]
                // line 2: issuer and date
                Issued by #text(style: "italic")[#cert.issuer]  #h(1fr) #date \
            ]
        }
    ]}
}

#let cvskills(info, isbreakable: true) = {
    if info.skills != none {block(breakable: isbreakable)[
        == Skills
        #if (info.skills != none) [
            #for group in info.skills [
                - *#group.category*: #group.skills.join(", ")
            ]
        ]
    ]}
}

#let cvlangsinterests(info, isbreakable: true) = {
    if (info.languages != none) or (info.interests != none) {block(breakable: isbreakable)[
        == Languages, Interests
        #if (info.languages != none) [
            #let langs = ()
            #for lang in info.languages {
                langs.push([#lang.language (#lang.fluency)])
            }
            - *Languages*: #langs.join(", ")
        ]

        #if (info.interests != none) [
            - *Interests*: #info.interests.join(", ")
        ]
    ]}
}

#let cvawards(info, isbreakable: true) = {
    if info.awards != none {block[
        == Scholarships & Awards
        #for award in info.awards {
            // parse ISO date strings into datetime objects
            let date = utils.strpdate(award.date)
            // create a block layout for each award entry
            block(width: 100%, breakable: isbreakable)[
                // line 1: award title and location
                #if award.url != none [
                    *#link(award.url)[#award.title]* #h(1fr) *#award.location* \
                ] else [
                    *#award.title* #h(1fr) *#award.location* \
                ]
                // line 2: issuer and date
                Issued by #text(style: "italic")[#award.issuer]  #h(1fr) #date \
                // summary or description
                #if award.highlights != none {
                    for hi in award.highlights [
                        - #eval(hi, mode: "markup")
                    ]
                } else {}
            ]
        }
    ]}
}

// ========================================================================== //

#show: doc => cvinit(doc)

#cvheading(cvdata, uservars)
#cvabout(cvdata)
#cveducation(cvdata)
#cvskills(cvdata)
#cvwork(cvdata)
#cvprojects(cvdata)
#cvaffiliations(cvdata)
#cvcertificates(cvdata)
#cvawards(cvdata)
#cvpublications(cvdata)
#cvlangsinterests(cvdata)
#cvreferences(cvdata)
#endnote()
