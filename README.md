# pw-blog

A blogging plugin for Pakyow Console.

## Config

**Title**  
The name of your blog.

**Description**  
What your blog is about.

**Language**  
The language your blog is written in.

## Routes

The following routes are defined when mounting this plugin.
Keep in mind that all routes will be prefixed with the mount point.
Override any route by defining a matching route in your app.

**Default (GET /)**  
Displays recent posts.

**Show (GET /:slug)**  
Displays a particular post.

**Archive (GET /archive)**  
Lists all posts, organized by date.

**Feed (GET /feed)**  
Delivers posts in RSS format.

## Views

The following views are used by this plugin.
Override any view by creating a matching view in `app/views/pw-blog`.

**index**  
List of posts.

**show**  
Post show page.

**archive**  
Archive page.

**_post-list**  
Post displayed in the list.

**_post-show**  
Post displayed on the show page.

**_post-archive**  
Post displayed on the archive page.

**_post-social**  
Social icons displayed at the bottom of the post.

**_metadata-list**  
Post metadata displayed in the list.

**_metadata-show**  
Post metadata displayed on the show page.

**_icon-facebook**  
Facebook icon.

**_icon-hackernews**  
Hacker News icon.

**_icon-reddit**  
Reddit icon.

**_icon-twitter**  
Twitter icon.
