export CODE_DIR=$HOME/Code

for project in `ls --indicator-style=none $CODE_DIR`
do
  hash -d -- $project=$CODE_DIR/$project
done

hash -d -- code=$CODE_DIR

