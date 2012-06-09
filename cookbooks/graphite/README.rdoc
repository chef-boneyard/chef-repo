= DESCRIPTION:

Installs and configures Graphite http://graphite.wikidot.com/

= REQUIREMENTS:

Ubuntu 10.04 (Lucid)

= ATTRIBUTES:

= USAGE:

recipe[graphite] should build a stand-alone Graphite installation.

recipe[graphite::ganglia] integrates with Ganglia. You'll want at
least one monitor node (i.e. recipe[ganglia]) node to be running
to use it.

= CAVEATS:

I didn't see an easy way to set Graphite's credentials easily.
I set those to root/root with an email address going no where.

Ships with two default schemas, stats.* (for Etsy's statsd) and a
catchall that matches anything. The catchall retains minutely data for
13 months, as in the default config. stats retains data every 10 seconds
for 6 hours, every minute for a week, and every 10 minutes for 5 years.
