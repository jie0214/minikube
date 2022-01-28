cd C:\Z_SYSTEM\Temp_GameClientRes_SVN
svn up
svn info
aws s3 rm s3://res.dev-royalgame.com/ --recursive
aws s3 rm s3://res.rcg666.com/ --recursive
aws s3 cp C:\Z_SYSTEM\Temp_GameClientRes_SVN s3://res.dev-royalgame.com/ --recursive --exclude ".svn/*"
aws s3 cp s3://res.dev-royalgame.com/index.html s3://res.dev-royalgame.com/index.html --cache-control no-cache
aws s3 cp s3://res.dev-royalgame.com/desk.js s3://res.dev-royalgame.com/desk.js --cache-control no-cache
aws s3 cp s3://res.dev-royalgame.com/meta.js s3://res.dev-royalgame.com/meta.js --cache-control no-cache
aws s3 cp s3://res.dev-royalgame.com/ s3://res.rcg666.com/ --recursive