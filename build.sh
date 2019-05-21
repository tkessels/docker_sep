#!/bin/bash
tag_latest="tabledevil/sep"
docker build --no-cache -t ${tag_latest} -f sep_dev.dockerfile  .
tag_version="${tag_latest}:$(docker run -it tabledevil/sep:latest tag)"
docker tag ${tag_latest} ${tag_version}
docker push ${tag_latest}
docker push ${tag_version}
