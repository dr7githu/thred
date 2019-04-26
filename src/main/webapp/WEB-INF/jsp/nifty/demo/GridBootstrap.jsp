<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="panel">
	<div class="panel-head">
		<h3 class="panel-title">Grid System</h3>
	</div>
	<div class="panel-body">
		<h3>Bootstrap Grid System</h3>
		<p>Bootstrap includes a responsive, mobile first fluid grid system that appropriately scales up to 12 columns as the device or viewport size increases. It includes predefined classes for easy layout options, as well as powerful mixins for generating
			more semantic layouts.</p>
	</div>
</div>



<div class="panel">
	<div class="panel-heading">
		<h3 class="panel-title">Grid options</h3>
	</div>
	<div class="panel-body">
		<p>See how aspects of the Bootstrap grid system work across multiple devices with a handy table.</p>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<th></th>
						<th class="text-center">
							<div class="pad-all">
								<i class="demo-pli-smartphone-3 icon-3x"></i>
							</div> Extra small devices<br> <small class="text-muted text-normal">Phones (&lt;768px)</small>
						</th>
						<th class="text-center">
							<div class="pad-all">
								<i class="demo-pli-tablet-2 icon-3x"></i>
							</div> Small devices<br> <small class="text-muted text-normal">Tablets (≥768px)</small>
						</th>
						<th class="text-center">
							<div class="pad-all">
								<i class="demo-pli-laptop icon-3x"></i>
							</div> Medium devices<br> <small class="text-muted text-normal">Desktops (≥992px)</small>
						</th>
						<th class="text-center">
							<div class="pad-all">
								<i class="demo-pli-monitor-2 icon-3x"></i>
							</div> Large devices<br> <small class="text-muted text-normal">Desktops (≥1200px)</small>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th class="text-nowrap" scope="row">Grid behavior</th>
						<td>Horizontal at all times</td>
						<td colspan="3">Collapsed to start, horizontal above breakpoints</td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row">Container width</th>
						<td>None (auto)</td>
						<td>750px</td>
						<td>970px</td>
						<td>1170px</td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row">Class prefix</th>
						<td><code>.col-xs-</code></td>
						<td><code>.col-sm-</code></td>
						<td><code>.col-md-</code></td>
						<td><code>.col-lg-</code></td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row"># of columns</th>
						<td colspan="4">12</td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row">Column width</th>
						<td class="text-muted">Auto</td>
						<td>~62px</td>
						<td>~81px</td>
						<td>~97px</td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row">Gutter width</th>
						<td colspan="4">30px (15px on each side of a column)</td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row">Nestable</th>
						<td colspan="4">Yes</td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row">Offsets</th>
						<td colspan="4">Yes</td>
					</tr>
					<tr>
						<th class="text-nowrap" scope="row">Column ordering</th>
						<td colspan="4">Yes</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>



<div class="panel">
	<div class="panel-heading">
		<h3 class="panel-title">Stacked-to-horizontal</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>
			Using a single set of
			<code>.col-md-*</code>
			grid classes, you can create a basic grid system that starts out stacked on mobile devices and tablet devices (the extra small to small range) before becoming horizontal on desktop (medium) devices. Place grid columns in any
			<code>.row</code>
			.
		</p>
		<hr>
		<div class="row">
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
			<div class="col-md-1">.col-md-1</div>
		</div>
		<div class="row">
			<div class="col-md-8">.col-md-8</div>
			<div class="col-md-4">
				<div class="row">
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
					<div class="col-md-1">1</div>
				</div>	
				<div class="row">
					<div class="col-md-2">2</div>
					<div class="col-md-2">2</div>
					<div class="col-md-2">2</div>
					<div class="col-md-2">2</div>
					<div class="col-md-2">2</div>
					<div class="col-md-2">
						<div class="row">
							<div class="col-md-1">1</div>
							<div class="col-md-1">1</div>
							<div class="col-md-1">1</div>
							<div class="col-md-1">1</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-4">.col-md-4</div>
			<div class="col-md-4">.col-md-4</div>
			<div class="col-md-4">.col-md-4</div>
		</div>
		<div class="row">
			<div class="col-md-6">.col-md-6</div>
			<div class="col-md-6">.col-md-6</div>
		</div>
	</div>
</div>



<div class="panel">
	<div class="panel-heading">
		<h3 class="panel-title">Mobile and desktop</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>
			Don't want your columns to simply stack in smaller devices? <br> Use the extra small and medium device grid classes by adding
			<code>.col-xs-*</code>
			<code>.col-md-*</code>
			to your columns. See the example below for a better idea of how it all works.
		</p>
		<!-- Stack the columns on mobile by making one full-width and the other half-width -->
		<div class="row">
			<div class="col-xs-12 col-md-8">.col-xs-12 .col-md-8</div>
			<div class="col-xs-6 col-md-4">.col-xs-6 .col-md-4</div>
		</div>

		<!-- Columns start at 50% wide on mobile and bump up to 33.3% wide on desktop -->
		<div class="row">
			<div class="col-xs-6 col-md-4">.col-xs-6 .col-md-4</div>
			<div class="col-xs-6 col-md-4">.col-xs-6 .col-md-4</div>
			<div class="col-xs-6 col-md-4">.col-xs-6 .col-md-4</div>
		</div>

		<!-- Columns are always 50% wide, on mobile and desktop -->
		<div class="row">
			<div class="col-xs-6">.col-xs-6</div>
			<div class="col-xs-6">.col-xs-6</div>
		</div>
	</div>
</div>



<div class="panel">
	<div class="panel-heading">
		<h3 class="panel-title">Mobile, tablet, desktop</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>
			Build on the previous example by creating even more dynamic and powerful layouts with tablet
			<code>.col-sm-*</code>
			classes.
		</p>
		<div class="row">
			<div class="col-xs-12 col-sm-6 col-md-8">.col-xs-12 .col-sm-6 .col-md-8</div>
			<div class="col-xs-6 col-md-4">.col-xs-6 .col-md-4</div>
		</div>
		<div class="row">
			<div class="col-xs-6 col-sm-4">.col-xs-6 .col-sm-4</div>
			<div class="col-xs-6 col-sm-4">.col-xs-6 .col-sm-4</div>
			<!-- Optional: clear the XS cols if their content doesn't match in height -->
			<div class="clearfix visible-xs-block"></div>
			<div class="col-xs-6 col-sm-4">.col-xs-6 .col-sm-4</div>
		</div>
	</div>
</div>



<div class="panel">
	<div class="panel-heading">
		<h3 class="panel-title">Column wrapping</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>If more than 12 columns are placed within a single row, each group of extra columns will, as one unit, wrap onto a new line.</p>
		<div class="row">
			<div class="col-xs-9">.col-xs-9</div>
			<div class="col-xs-4">
				.col-xs-4<br>Since 9 + 4 = 13 &gt; 12, this 4-column-wide div gets wrapped onto a new line as one contiguous unit.
			</div>
			<div class="col-xs-6">
				.col-xs-6<br>Subsequent columns continue along the new line.
			</div>
		</div>
	</div>
</div>



<div class="panel">
	<div class="panel-heading demo-show-grid">
		<h3 class="panel-title">Responsive column resets</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>
			With the four tiers of grids available you're bound to run into issues where, at certain breakpoints, your columns don't clear quite right as one is taller than the other. To fix that, use a combination of a
			<code>.clearfix</code>
			.
		</p>
		<div class="row">
			<div class="col-xs-6 col-sm-3">.col-xs-6 .col-sm-3</div>
			<div class="col-xs-6 col-sm-3">.col-xs-6 .col-sm-3</div>

			<!-- Add the extra clearfix for only the required viewport -->
			<div class="clearfix visible-xs-block"></div>

			<div class="col-xs-6 col-sm-3">.col-xs-6 .col-sm-3</div>
			<div class="col-xs-6 col-sm-3">.col-xs-6 .col-sm-3</div>
		</div>
	</div>
</div>



<div class="panel">
	<div class="panel-heading demo-show-grid">
		<h3 class="panel-title">Offsetting columns</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>
			Move columns to the right using
			<code>.col-md-offset-*</code>
			classes. These classes increase the left margin of a column by
			<code>*</code>
			columns. For example,
			<code>.col-md-offset-4</code>
			moves
			<code>.col-md-4</code>
			over four columns.
		</p>
		<div class="row">
			<div class="col-md-4">.col-md-4</div>
			<div class="col-md-4 col-md-offset-4">.col-md-4 .col-md-offset-4</div>
		</div>
		<div class="row">
			<div class="col-md-3 col-md-offset-3">.col-md-3 .col-md-offset-3</div>
			<div class="col-md-3 col-md-offset-3">.col-md-3 .col-md-offset-3</div>
		</div>
		<div class="row">
			<div class="col-md-6 col-md-offset-3">.col-md-6 .col-md-offset-3</div>
		</div>
	</div>
</div>



<div class="panel">
	<div class="panel-heading demo-show-grid">
		<h3 class="panel-title">Nesting columns</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>
			To nest your content with the default grid, add a new
			<code>.row</code>
			and set of
			<code>.col-sm-*</code>
			columns within an existing
			<code>.col-sm-*</code>
			column. Nested rows should include a set of columns that add up to 12 or fewer (it is not required that you use all 12 available columns).
		</p>
		<div class="row">
			<div class="col-sm-9">
				Level 1: .col-sm-9
				<div class="row">
					<div class="col-xs-8 col-sm-6">Level 2: .col-xs-8 .col-sm-6</div>
					<div class="col-xs-4 col-sm-6">Level 2: .col-xs-4 .col-sm-6</div>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="panel">
	<div class="panel-heading demo-show-grid">
		<h3 class="panel-title">Column ordering</h3>
	</div>
	<div class="panel-body demo-show-grid">
		<p>
			Easily change the order of our built-in grid columns with
			<code>.col-md-push-*</code>
			and
			<code>.col-md-pull-*</code>
			modifier classes.
		</p>
		<div class="row">
			<div class="col-md-9 col-md-push-3">.col-md-9 .col-md-push-3</div>
			<div class="col-md-3 col-md-pull-9">.col-md-3 .col-md-pull-9</div>
		</div>
	</div>
</div>





<!-- SCROLL PAGE BUTTON -->
<!--===================================================-->
<button class="scroll-top btn">
	<i class="pci-chevron chevron-up"></i>
</button>
<!--===================================================-->




