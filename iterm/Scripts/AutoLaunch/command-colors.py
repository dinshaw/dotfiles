#!/usr/bin/env python3

import iterm2
import re

async def SetPresetInSession(connection, session, preset_name):
    preset = await iterm2.ColorPreset.async_get(connection, preset_name)
    if not preset:
        return
    profile = await session.async_get_profile()
    if not profile:
        return
    await profile.async_set_color_preset(preset)

async def main(connection):
    app = await iterm2.async_get_app(connection)

    async def monitor(session_id):
        session = app.get_session_by_id(session_id)
        if not session:
            return

        while True:
            async with iterm2.VariableMonitor(
                connection, iterm2.VariableScopes.SESSION, "commandLine", session_id
                ) as mon:
                command_str = await mon.async_get()
                print(command_str)
            if re.search("rails s|bin/dev|localhost:3000", command_str):
                await SetPresetInSession(connection, session, 'Solarized Light')
            elif re.search("rails c", command_str):
                await SetPresetInSession(connection, session, 'Borland')
            else:
                await SetPresetInSession(connection, session, 'Arthur')

    await iterm2.EachSessionOnceMonitor.async_foreach_session_create_task(app, monitor)

iterm2.run_forever(main)
