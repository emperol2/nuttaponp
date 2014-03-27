======================================================================
# Objects definition
top-nav             css          top-nav
map                 css          map
latest-news         css          latest-news
shred-view-btn      css
owners-group-btn    css
breadcrumbs         css
shred-tech-banner   id
footer-text         css
footer              id


======================================================================
# Spec definition

@ Section 1. Testing header and left menu
----------------------------------------------------------------------
top-nav
        above: breadcrumbs 10 to 30 px bottom

map
        near: top-nav > 50px top right

latest-news
        below: map 5 to 20 px

shred-view-btn
        below: latest-news 5 to 20 px

owners-group-btn
        below: shred-view-btn 5 to 20 px

breadcrumbs
        above: shred-tech-banner 5 to 20 px

shred-tech-banner
        visible
        inside: container < 5 px right
        below: breadcrumbs 5 to 10 px
        above: footer-text 5 to 20 px

footer-text
        visible
        above: footer 5 to 10 px

footer
        visible
        inside: container < 10 px bottom
        text contains: SERVICE HOTLINE
