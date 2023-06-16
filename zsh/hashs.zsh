export CODE_DIR=$HOME/Code

for project in `ls --indicator-style=none $CODE_DIR`
do
  hash -d -- $project=$CODE_DIR/$project
done

hash -d -- code=$CODE_DIR

for project in `fd --type d 'stack-' --maxdepth 1 --base-directory $CODE_DIR/stack-development`
do
  project=${project#./stack-}
  hash -d -- ${project%/}=$CODE_DIR/stack-development/stack-$project
done
