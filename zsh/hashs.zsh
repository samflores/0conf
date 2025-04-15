export CODE_DIR=$HOME/Code

for project in $(/usr/bin/fd --type d 'stack-' --maxdepth 1 --base-directory $CODE_DIR/stack-development)
do
  project=${project#stack-}
  hash -d -- ${project%/}=$CODE_DIR/stack-development/stack-$project
done

for project in `ls $CODE_DIR`
do
  hash -d -- $project=$CODE_DIR/$project
done

hash -d -- code=$CODE_DIR
