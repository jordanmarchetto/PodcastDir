This creates a podcast/RSS feed from a directory of mp3/mp4 files.

# Configuration
```
PODCAST_EPISODE_PATH="/some/path/to/podcast/files/"
PODCAST_TITLE="Podcast Title"
PODCAST_AUTHOR="Author"
PODCAST_DESCRIPTION="A test podcast."
```

`PODCAST_EPISODE_PATH` represents a folder comprised of media files.  It can be any path on the host machine, and by default will get mounted to the docker image.  The server iterates over the files and builds an episode for each file.  The RSS feed will be available at: `http://localhost:3000/feed`

Additionally, all assets from the path above will be reachable via: `http://localhost:3000/assets/filename.mp3`


# Deploying
- pull the repo on your webserver
- copy `.env.sample` to `.env` 
- make necessary changes
- run `docker compose up`
- figure out whatever routing you might need to hit your docker container



# Why use this?

Maybe you have a child with a Yoto Player and you don't want to buy those expensive blank cards.  You can build a podcast, add that as a source, and then you can play songs off the podcast instead of loading the songs to the cards.

# Future 

Currently, this is 99% stock rails code, I just added the two controllers.  I've spent maybe 3 hours on this project and it works how I want it to.  In the future, I could:
- parse mp3s for better metadata (title/author/created_at)
- cache the feed instead of generating a new rss feed each request
- handle more media types
- UI for editing mp3 metadata
- episode order
- multiple podcasts