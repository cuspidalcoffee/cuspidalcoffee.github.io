# Career History

Here I summarize the various achievements, tasks and responsibilities I've had at work in the past.
I'm not going to name the companies I worked for for privacy reasons.
I don't have any issues sharing those if you're giving me an offer or an interview, but I firmly believe that you should be basing that decision based on what I've done, and not so much who I did it for.

## Admin

I've worked as an administrator (system, network, devops) with a large variety of responsibilities.
These were conferred due to me generally being the person with the most unix knowledge in the company (in multiple instances), largely due to the fact that I've been working with linux for over a decade.

Here are a few of the things I've done:
* Inherit an abandoned, undocumented and broken deployment system (puppet, which could no longer complete a run).
  Port it to something more managable (in this specific case it was ansible) and increase deployment turnover several times over.
  Prior to me joining the role, the routine upgrade (between ubuntu lts versions) to the datacenter machines' software took 6 months due to the broken deployment system.
  With my changes, the next one was completed in 2 weeks.
* Migrating EOL and falling apart infrastructure with no downtime.
* Setting up a deployment system that developers could interact with (without breaking anything, which is a common negative side-effect of direct CI/CD).
* Creating an on-demand automatic scaling system for a smaller product series.
  Kubernetes would have been overkill (~3 hosts needed on average), but easy horizontal scaling was still a strong requirement (due to peak usage periods).
* Cooperating with the QA department to create standardized compliance procedures, documents, reports, and verifying compliance of the actual infrastructure.
* Architecting and organizing the transition from a single server product architecture to a redudnant and efficient cluster, seeing performance increases of up to 20x (and cost increases of only ~3x).

I'm deeply familiar with unix-like systems, especially linux.
In particular, I have deep experience with industry standard distributions such as CentOS and Ubuntu, but also leaner systems such as Arch, Alpine and Gentoo.

I'm familiar with services of various kinds, anything from go-based storage solutions (such as minio), to database systems (like postgres and mysql, including clustering), to development tools (such as git, including hosting systems like gitea and gitlab), to deployment tools (including ansible and saltstack) and even development platforms (such as Apache Tomcat).

Coming from a background in programming, I can quickly identify potential issues in projects and their architectures. I have a history of prioritizing a clean system/environment and quality code, which directly results in maintainable programs and infrastructure, saving immeasurable value in future maintenance, or even clean slate rewrites.

## Developer

Prior to pivoting to administration work, I spent some time as a developer.
Within this relatively short time period, I redesigned a product architecture to increase its speed and capacity multiple times over, rewrote upstream-broken server software, and refactored multiple subsystems.
I performed analysis of design decisions, including identifying multiple race conditions, and then fixing them.
I also acted in a support role for the admin team to help resolve difficulties caused by the old infrastructure, which led me to later pivot to having my primary role be that of an admin.
