======================================================================
# Objects definition
top-nav             css          top-nav
wrapper             css
shred-tech-heading  css
list-section        css
technology          css
custom-system       css
manual-specs        css
action-drop-down    id
whole-list-table    id
list-img            id
list-heading        css
list-content        css
list-link           css
footer-text         css
footer              id


======================================================================
# Spec definition

@ Section 1. Testing Shred-tech product list page
----------------------------------------------------------------------
top-nav
        above: breadcrumbs 10 to 30 px bottom

shred-tech-heading
        text contains: Shredding & Recycling Systems

list-section
        below: shred-tech-heading 1 to 20 px bottom
        inside: wrapper < 10 px left

technology
        below: list-section 5 to 20 px top

custom-system
        below: technology 5 to 20 px top
        above: manual-specs 5 to 20 px bottom

manual-specs
        below: custom-system 5 to 20 px top

action-drop-down
        inside: content < 20 px top right
        above: whole-list-table 5 to 10 px bottom

list-img
        above: list-heading 5 to 20 px bottom

list-heading
        above: list-content 5 to 20 px bottom

list-content
        above: list-link 5 to 20 px bottom

list-link
        text contains: More details

footer-text
        visible
        above: footer 5 to 10 px

footer
        visible
        inside: container < 10 px bottom
        text contains: SERVICE HOTLINE
