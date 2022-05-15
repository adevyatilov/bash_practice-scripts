#!/bin/bash 

# Практика по написнаию bash скриптов
# Узнать сколько весят образы можно следующей командой 
# docker system df --format "{{.Type}} {{.Size}}" | grep -oP "(?<=Images )[0-9\.]+.+$" 


# Допустим команда docker system df нам неизвестна, тогда напишим скрипт на bash, который вернет общий размер образов
images_raw_size=$(docker image ls --format {{.Size}})
images_size_MB=$(echo ${images_raw_size} | grep -oP "[0-9\.]+(?=MB)")

total_size_images_MB=0
for image_size_MB in ${images_size_MB[@]}
do
  total_size_images_MB=$(echo "${total_size_images_MB} + ${image_size_MB}" | bc)
done
echo "total_size_images = ${total_size_images_MB}MB"


# На момент написания скрипта заметил, что результат вывода команды docker system df... и результат работы моего скрипта отличается:
# 1) ./total_size_images.sh --> total_size_images = 424.48MB
# 2) docker system df --format "{{.Type}} {{.Size}}" | grep -oP "(?<=Images )[0-9\.]+.+$"  --> 423.2MB
# Это связано с тем, что docker переиспользует слои, и данный скрипт не даст точный результат.