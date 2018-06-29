IMAGE=quay.io/lunarway/pagerbot
TAG=latest

build: 
		docker build -f Dockerfile -t $(IMAGE):$(TAG) .

push:
		docker push $(IMAGE):$(TAG)