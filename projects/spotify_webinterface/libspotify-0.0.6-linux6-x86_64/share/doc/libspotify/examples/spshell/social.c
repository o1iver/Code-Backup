/**
 * Copyright (c) 2006-2010 Spotify Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#include "spshell.h"
#include "cmd.h"

static const char *relationtypes[] = {
	"Unknown",
	"No relation",
	"Unidirectional",
	"Bidirectional"
};

/**
 *
 */
int cmd_friends(int argc, char **argv)
{
	int nf = sp_session_num_friends(g_session);
	int i;

	for(i = 0; i < nf; i++) {
		sp_user *u = sp_session_friend(g_session, i);
		sp_relation_type rt = sp_user_relation_type(g_session, u);

		printf("  %-20s [%s]\n", sp_user_canonical_name(u), relationtypes[rt]);
		printf("\tSpotify displayname: %s\n", sp_user_display_name(u));
		printf("\t           Realname: %s\n", sp_user_full_name(u));
		printf("\t            Picture: %s\n", sp_user_picture(u));
		printf("\n");
	}
	return 1;
}

void plc_pl_added(sp_playlistcontainer *pc, sp_playlist *playlist, int position, void *userdata)
{
	const char *canonical_username = (const char *) userdata ? userdata : sp_user_display_name(sp_session_user(g_session));
printf("playlistcontainer for user %s: pl %s added at position %d\n",
       canonical_username, sp_playlist_name(playlist), position);
	
}
void plc_pl_removed(sp_playlistcontainer *pc, sp_playlist *playlist, int position, void *userdata)
{
	const char *canonical_username = (const char *) userdata ? userdata : sp_user_display_name(sp_session_user(g_session));
printf("playlistcontainer for user %s: pl %s removed at position %d\n",
       canonical_username, sp_playlist_name(playlist), position);

}
void plc_pl_moved(sp_playlistcontainer *pc, sp_playlist *playlist, int position, int new_position, void *userdata)
{
	const char *canonical_username = (const char *) userdata ? userdata : sp_user_display_name(sp_session_user(g_session));
printf("playlistcontainer for user %s: pl %s moved from %d to %d\n",
       canonical_username, sp_playlist_name(playlist), position, new_position);
}

void plc_loaded(sp_playlistcontainer *plc, void *userdata)
{
	const char *canonical_username = (const char *)userdata;
	printf("playlistcontainer for user %s loaded\n",
	       canonical_username ? canonical_username : sp_user_display_name(sp_session_user(g_session)));
}

sp_playlistcontainer_callbacks plc_callbacks = {
	plc_pl_added,
	plc_pl_removed,
	plc_pl_moved,
	plc_loaded,
};

int cmd_published_subscribe(int argc, char **argv)
{
	const char *user = NULL;
	int n;
	sp_playlistcontainer *plc;
	if (argc > 1)
		user = argv[1];
	plc = sp_session_publishedcontainer_for_user(g_session, user);
	if (plc) {
		sp_user *ui = sp_playlistcontainer_owner(plc);
		printf("playlistcontainer for user %s\n", ui ? sp_user_display_name(ui) : "<unknown>");

		/* Make sure we're not registering duplicate callbacks */
		sp_playlistcontainer_remove_callbacks(plc, &plc_callbacks, (void*)user);
		sp_playlistcontainer_add_callbacks(plc, &plc_callbacks, (void*)user);
		for (n = sp_playlistcontainer_num_playlists(plc); n; --n) {
			sp_playlist *pl = sp_playlistcontainer_playlist(plc, n);
			if (pl) {
				printf("playlist: %s\n", sp_playlist_name(pl));
			} else {
				printf("unknown playlist at position %d\n", n);
			}
		}
	}
	return 1;
}

int cmd_published_unsubscribe(int argc, char **argv)
{
	const char *user = NULL;
	if (argc > 1)
		user = argv[1];
	sp_session_publishedcontainer_for_user_release(g_session, user);
	return 1;
}
