# PagerBot-k8s

**This project was originaly created by the great people of [stripe-contrip](https://github.com/stripe-contrib/pagerbot). This fork adapts the deployment of pagerbot to kubernetes instead of the original deployment model of heroku.**

Pagerbot is a bot that makes managing [PagerDuty](http://www.pagerduty.com/) on-call schedules easier. It currently supports IRC and Slack, and can be easily deployed to kubernetes.

Pagerbot uses [Chronic](https://github.com/mojombo/chronic) for natural language date and time parsing.

Sample
=====

![ScreenShot](public/pics/animation.gif)

Usage
======

The easiest way to test this project out is to use `minikube` on your local machine. This projects wraps the deployment of pagerbot using `helm` and allow you to run the bot with the following command, once helm is initialized: 

```
helm install .  --name pagerbot
```

This command deploys three services to your kubernetes cluster.  

* pagerbot  
  * this is the bot itself
* pagerbot-admin
  * this is the administration panel, for setting up integration with pagerduty and slack, etc.
* mongo
  * data store used for storing configurations

Going through the admin page shouldn't take much longer than 8 minutes. The admin page also contains detailed information on how to make the bot join your channel.


Plugins
=======

Currently pagerbot supports the following commands (prefix all of them with bot name and a colon, e.g. `pagerbot:`):

| Plugin | Example | Notes |
| ----------------- |:---------------------------------------------------:| -----|
| - | `help` | Short list of all commands pagerbot knows. |
| - | `manual` | Show in-depth explanation about each command. |
| - | `who is on primary now?` | Find out who is on a specific schedule at time. |
| - | `when am I on product?` | Find out who is on a specific schedule at time. |
| Schedule override | `put me on triage for 30 minutes` | Overrides the current schedule for a duration. |
| Schedule override | `put carl on primary from 3 AM until 4 AM August 24th` | |
| Call | `call sys because admin server is acting funky` | Send email to \<teamname\>\<email-suffix\>, where email-suffix is set in admin. |
| Call person | `get andrew because we need to credential people` | Triggers an pagerduty issue for person. |
| Switch shift | `put amy on triage during carl's shift on August 11th` | Take over a single shift on a specific day. |
| Reload | `reload` | Load user and schedule changes from pagerduty. |
| Add Alias | `alias karl@mycompany.com as karl` | Add a new alias for person or schedule. |

Local development
=============

Easiest way to run pagerbot locally is via docker and [docker-compose](https://docs.docker.com/compose/).

```bash
# Running tests
docker-compose run pagerbot rake test

# Opening the admin interface to configure the bot. Accessible via `localhost:4567`
# The interface will auto-reload on file changes (though html/javascript may be cached).
docker-compose up --build pagerbot-admin

# Run the bot itself locally
docker-compose up --build pagerbot
```

For developing new capabilities, PagerDuty has two different APIs:

* The [Integration API](https://developer.pagerduty.com/documentation/integration/events) is a high-availability endpoint for triggering and updating incidents.
* The [REST API](https://developer.pagerduty.com/documentation/rest) provides CRUD for most PagerDuty account objects, such as users, schedules, escalation policies, etc

Deploying in kubernetes
=======

To deploy it to kubernetes:

Start minikube
```bash
minikube start
```
Install helm in your cluster
```
helm init
```
Go to the helm chart
```
cd helmchart/pagerbot
````
Install the chart:
```
helm install .  --name pagerbot
```
To open the admin page, port-forward the pagerbot-admin webapp to your localhost:4567:
```
kubectl port-forward <pagerbot-admin-*> 4567:4567
```
After completing the configuration in the admin panel, update the values.yaml file with `deployed: true`
```
pagerbot:
  name: pagerbot
  deployed: true
```
and lastly upgrade the deployment:
```
helm upgrade pagerbot .
```

FAQ
====

### How can I secure the admin interface?

Set the enviroment variable called `PROTECT_ADMIN` to be your desired password. Instructions for changing an enviroment variable are listed in the next FAQ.

When using the admin interface, enter the same password, the username can be arbitrary.

