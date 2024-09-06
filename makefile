up:
	docker compose up -d

down:
	docker compose down --volumes --remove-orphans

namenode:
	docker compose exec namenode bash

# 1. Copy input.txt to hdfs
copy-input-hdfs:
	docker compose exec namenode hdfs dfs -put /input.txt /input.txt

# 2. Run the wordcount program
run-wordcount:
	docker compose exec namenode hadoop jar /wordcount.jar /input.txt /output

# 3. Output the wordcount results
output-wordcount:
	docker compose exec namenode hdfs dfs -cat /output/*

# Run all the commands
run-all:
	make copy-input-hdfs
	make run-wordcount
	make output-wordcount